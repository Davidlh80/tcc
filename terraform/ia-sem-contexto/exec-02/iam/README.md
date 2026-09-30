# IAM Role com IAM Policy Anexada

Blueprint Terraform para provisionar uma IAM Role na AWS com uma IAM Policy de privilegio minimo anexada diretamente a ela (a policy nunca fica solta, sem principal associado).

## Recursos criados

- `aws_iam_role.this`: IAM Role com trust policy (assume role) restrita aos principals informados em `trusted_service_principals`.
- `aws_iam_policy.this`: IAM Policy com statement explicito de `actions` e `resources`, sem wildcards por padrao.
- `aws_iam_role_policy_attachment.this`: anexa a policy diretamente a role.

## Decisoes de seguranca por padrao

- `allowed_actions` e `allowed_resource_arns` nao aceitam `"*"` a menos que `allow_wildcard_actions` / `allow_wildcard_resources` sejam definidos explicitamente como `true`.
- `max_session_duration` limitado entre 3600 e 43200 segundos (limites validos da AWS).
- Suporte opcional a `permissions_boundary_arn` para limitar o escopo maximo de permissoes da role.
- Suporte opcional a `external_id` na trust policy, recomendado para cenarios de assume role cross-account.
- Nenhum valor sensivel ou credencial e definido no codigo; toda configuracao e feita via variaveis.

## Uso

```
terraform init -backend=false
terraform validate
```

Para um plano real, informe valores adequados as variaveis (ex.: via `terraform.tfvars` ou `-var`), especialmente `trusted_service_principals`, `allowed_actions` e `allowed_resource_arns`, ajustando-os ao caso de uso real antes de aplicar.

## Inputs principais

| Nome | Descricao | Default |
|---|---|---|
| `aws_region` | Regiao AWS | `us-east-1` |
| `role_name` | Nome da IAM Role | `app-role` |
| `trusted_service_principals` | Service principals que podem assumir a role | `["ec2.amazonaws.com"]` |
| `external_id` | External ID exigido no AssumeRole | `null` |
| `permissions_boundary_arn` | ARN de permissions boundary | `null` |
| `policy_name` | Nome da IAM Policy | `app-role-policy` |
| `allowed_actions` | Actions permitidas na policy | `["s3:GetObject", "s3:ListBucket"]` |
| `allowed_resource_arns` | Recursos alvo das actions | ver `variables.tf` |

## Outputs principais

- `role_name`, `role_arn`, `role_id`
- `policy_name`, `policy_arn`
- `policy_attachment_id`

## Observacoes

- Ajuste `trusted_service_principals` para o(s) service principal(is) real(is) que devem assumir a role (ex.: `lambda.amazonaws.com`, `ecs-tasks.amazonaws.com`) ou substitua o bloco `principals` em `main.tf` caso o principal de confianca seja uma conta AWS ou um usuario/role especifico.
- Revise `allowed_actions` e `allowed_resource_arns` para refletir o principio de privilegio minimo antes de qualquer `terraform apply`.
