#!/usr/bin/env bash

set -uo pipefail

scenario=""
resource=""
limit=0
report="resultados/localstack/results.csv"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --scenario)
      scenario="$2"
      shift 2
      ;;
    --resource)
      resource="$2"
      shift 2
      ;;
    --limit)
      limit="$2"
      shift 2
      ;;
    --report)
      report="$2"
      shift 2
      ;;
    *)
      echo "Argumento desconhecido: $1"
      exit 2
      ;;
  esac
done

if [[ ! "$scenario" =~ ^(manual|ia-sem-contexto|ia-com-contexto)$ ]]; then
  echo "Cenario invalido: $scenario"
  exit 2
fi

if [[ ! "$resource" =~ ^(s3|iam|security-group)$ ]]; then
  echo "Recurso invalido: $resource"
  exit 2
fi

if ! [[ "$limit" =~ ^[0-9]+$ ]]; then
  echo "O limite deve ser um numero inteiro maior ou igual a zero."
  exit 2
fi

mkdir -p "$(dirname "$report")"
logs_dir="$(dirname "$report")/logs/${scenario}/${resource}"
mkdir -p "$logs_dir"

directories_file="$(dirname "$report")/directories-${scenario}-${resource}.txt"
: > "$directories_file"

mapfile -t candidates < <(
  find "terraform/$scenario" -type f -name '*.tf' -printf '%h\n' 2>/dev/null |
    sort -u
)

selected=0
for directory in "${candidates[@]}"; do
  if [ "$(basename "$directory")" != "$resource" ]; then
    continue
  fi

  echo "$directory" >> "$directories_file"
  selected=$((selected + 1))

  if [ "$limit" -gt 0 ] && [ "$selected" -ge "$limit" ]; then
    break
  fi
done

echo "Diretorios selecionados para $scenario/$resource:"
cat "$directories_file"

if [ ! -s "$directories_file" ]; then
  echo "Nenhum template Terraform encontrado para $scenario/$resource."
  exit 2
fi

echo 'scenario,resource,directory,init,plan,apply,verify,destroy,result' > "$report"

export TF_VAR_aws_region=us-east-1
export TF_VAR_region=us-east-1
export TF_VAR_environment=dev
export TF_VAR_system=tcc
export TF_VAR_purpose=experiment
export TF_VAR_bucket_purpose=experiment
export TF_VAR_enable_versioning=true
export TF_VAR_versioning_enabled=true
export TF_VAR_force_destroy=true
export TF_VAR_tags='{"Project":"tcc","CostCenter":"experimental"}'
export TF_VAR_additional_tags='{"Project":"tcc","CostCenter":"experimental"}'
export TF_VAR_allowed_actions='["s3:GetObject","s3:ListBucket"]'
export TF_VAR_allowed_resources='["arn:aws:s3:::tcc-experiment","arn:aws:s3:::tcc-experiment/*"]'
export TF_VAR_allowed_ports='[443]'
export TF_VAR_allowed_cidrs='["10.0.0.0/8"]'

if [ "$resource" = "security-group" ]; then
  vpc_id=$(aws --endpoint-url="$AWS_ENDPOINT_URL" ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --query 'Vpc.VpcId' \
    --output text)

  if [ -z "$vpc_id" ] || [ "$vpc_id" = "None" ]; then
    echo "Nao foi possivel criar a VPC de apoio no LocalStack."
    exit 2
  fi

  export TF_VAR_vpc_id="$vpc_id"
fi

read_output() {
  local directory="$1"
  shift

  local output_name
  local output_value
  for output_name in "$@"; do
    output_value=$(tflocal -chdir="$directory" output -raw "$output_name" 2>/dev/null || true)
    if [ -n "$output_value" ]; then
      printf '%s' "$output_value"
      return 0
    fi
  done

  return 1
}

failures=0

while IFS= read -r directory; do
  echo "::group::Testando $directory"

  subject_id=$(basename "$(dirname "$directory")")
  unique_name=$(printf 'tcc-%s-%s-%s' "$scenario" "$subject_id" "${GITHUB_RUN_ID:-local}" |
    tr '_' '-' |
    tr -cd 'a-zA-Z0-9-' |
    tr '[:upper:]' '[:lower:]' |
    cut -c1-63)

  export TF_VAR_bucket_name="$unique_name"
  export TF_VAR_policy_name="$unique_name"
  export TF_VAR_security_group_name="$unique_name"
  export TF_VAR_name="$unique_name"

  safe_name=$(echo "$directory" | tr '/\\' '__')
  init_log="$logs_dir/${safe_name}-init.log"
  plan_log="$logs_dir/${safe_name}-plan.log"
  apply_log="$logs_dir/${safe_name}-apply.log"
  verify_log="$logs_dir/${safe_name}-verify.log"
  destroy_log="$logs_dir/${safe_name}-destroy.log"

  init_result=failed
  plan_result=skipped
  apply_result=skipped
  verify_result=skipped
  destroy_result=skipped

  rm -rf \
    "$directory/.terraform" \
    "$directory/.terraform.lock.hcl" \
    "$directory/terraform.tfstate" \
    "$directory/terraform.tfstate.backup" \
    "$directory/tfplan"

  if tflocal -chdir="$directory" init -backend=false -input=false -no-color >"$init_log" 2>&1; then
    init_result=passed

    if tflocal -chdir="$directory" plan -input=false -no-color -out=tfplan >"$plan_log" 2>&1; then
      plan_result=passed

      if tflocal -chdir="$directory" apply -input=false -no-color -auto-approve tfplan >"$apply_log" 2>&1; then
        apply_result=passed

        case "$resource" in
          s3)
            identifier=$(read_output "$directory" bucket_name bucket_id || true)
            if [ -n "$identifier" ] && aws --endpoint-url="$AWS_ENDPOINT_URL" s3api head-bucket --bucket "$identifier" >"$verify_log" 2>&1; then
              verify_result=passed
            else
              verify_result=failed
            fi
            ;;
          iam)
            identifier=$(read_output "$directory" policy_arn iam_policy_arn arn || true)
            if [ -n "$identifier" ] && aws --endpoint-url="$AWS_ENDPOINT_URL" iam get-policy --policy-arn "$identifier" >"$verify_log" 2>&1; then
              verify_result=passed
            else
              verify_result=failed
            fi
            ;;
          security-group)
            identifier=$(read_output "$directory" security_group_id sg_id id || true)
            if [ -n "$identifier" ] && aws --endpoint-url="$AWS_ENDPOINT_URL" ec2 describe-security-groups --group-ids "$identifier" >"$verify_log" 2>&1; then
              verify_result=passed
            else
              verify_result=failed
            fi
            ;;
        esac
      else
        apply_result=failed
      fi
    else
      plan_result=failed
    fi
  fi

  if [ "$init_result" = passed ]; then
    if tflocal -chdir="$directory" destroy -input=false -no-color -auto-approve >"$destroy_log" 2>&1; then
      destroy_result=passed
    else
      destroy_result=failed
    fi
  fi

  for log_file in "$init_log" "$plan_log" "$apply_log" "$verify_log" "$destroy_log"; do
    if [ -f "$log_file" ]; then
      cat "$log_file"
    fi
  done

  if [ "$init_result" = passed ] && \
    [ "$plan_result" = passed ] && \
    [ "$apply_result" = passed ] && \
    [ "$verify_result" = passed ] && \
    [ "$destroy_result" = passed ]; then
    result=passed
  else
    result=failed
    failures=$((failures + 1))
  fi

  echo "$scenario,$resource,$directory,$init_result,$plan_result,$apply_result,$verify_result,$destroy_result,$result" >> "$report"
  echo "Resultado: init=$init_result plan=$plan_result apply=$apply_result verify=$verify_result destroy=$destroy_result"
  echo "::endgroup::"
done < "$directories_file"

cat "$report"

if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "failures=$failures" >> "$GITHUB_OUTPUT"
  echo "templates=$selected" >> "$GITHUB_OUTPUT"
fi

{
  echo "## LocalStack: $scenario / $resource"
  echo
  echo "Templates avaliados: $selected"
  echo "Templates com falha: $failures"
  echo
  echo '```csv'
  cat "$report"
  echo '```'
} >> "${GITHUB_STEP_SUMMARY:-/dev/null}"

exit 0
