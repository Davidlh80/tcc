# IAM Role com IAM Policy anexada

Blueprint Terraform que provisiona:

- Uma IAM Policy com permissoes explicitas (sem wildcard total de actions e, por padrao, sem wildcard de recursos).
- Uma IAM Role cuja trust policy (assume role policy) permite apenas os principals listados em `trusted_principal_arns` — nunca `"*"` ou `AWS: "*"`.
- O attachment entre a policy e a role, garantindo que a policy nunca fique solta sem nenhum principal associado.

## Uso

```
module "iam_role_with_policy" {
  source = "./"

  role_name   = "app-read-only-role"
  policy_name = "app-read-only-policy"

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/ci-cd-pipeline"
  ]

  policy_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  policy_resources = [
    "arn:aws:s3:::meu-bucket-exemplo",
    "arn:aws:s3:::meu-bucket-exemplo/*"
  ]

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

## Boas praticas aplicadas

- **Trust policy restrita**: `trusted_principal_arns` e obrigatorio, nao pode ser vazio e nao pode conter `"*"`.
- **External ID opcional**: use `external_id` para mitigar o problema do "confused deputy" ao permitir assume role entre contas.
- **Sem permissoes administrativas**: `policy_actions` nao aceita o wildcard total `"*"`.
- **Recursos explicitos**: `policy_resources` exige ARNs explicitos; o uso de `"*"` so e permitido definindo `allow_wildcard_resources = true` de forma consciente.
- **Tags**: aplicadas tanto na role quanto na policy para rastreabilidade.

## Validacao

```
terraform init -backend=false
terraform validate
```

Nao e necessario backend remoto nem credenciais reais para executar os comandos acima.

## Inputs principais

| Nome | Descricao | Obrigatorio |
|---|---|---|
| role_name | Nome da IAM Role | Sim |
| policy_name | Nome da IAM Policy | Sim |
| trusted_principal_arns | ARNs autorizados a assumir a role | Sim |
| policy_resources | ARNs dos recursos cobertos pela policy | Sim |
| policy_actions | Actions permitidas | Nao (default minimo de leitura em S3) |
| external_id | External ID para a trust policy | Nao |
| allow_wildcard_resources | Permite `"*"` em policy_resources | Nao (default false) |
| max_session_duration | Duracao maxima da sessao assumida | Nao (default 3600) |
| tags | Tags aplicadas aos recursos | Nao |

## Outputs principais

| Nome | Descricao |
|---|---|
| role_arn | ARN da role criada |
| role_name | Nome da role criada |
| policy_arn | ARN da policy criada |
| policy_name | Nome da policy criada |
| policy_attachment_id | ID do attachment entre policy e role |
