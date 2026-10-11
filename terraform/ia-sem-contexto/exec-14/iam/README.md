# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Policy gerenciada e anexa-la a uma IAM Role na AWS, com trust policy (assume role policy) restrita a um unico principal configuravel.

## Recursos criados

- `aws_iam_role.this` — IAM Role com trust policy restrita ao principal informado em `trusted_principal_arn`.
- `aws_iam_policy.this` — IAM Policy gerenciada com as actions e recursos informados em `allowed_actions` e `resource_arns`.
- `aws_iam_role_policy_attachment.this` — anexa a policy criada a role criada, garantindo que a policy nunca fique sem nenhum principal associado.

## Decisoes de seguranca

- A trust policy (`data.aws_iam_policy_document.assume_role`) aceita exatamente um principal AWS, definido pela variavel `trusted_principal_arn`. A variavel possui `validation` que rejeita o valor `"*"` e exige um ARN no formato `arn:aws:iam::<account-id>:...` ou `arn:aws:sts::<account-id>:...`, impedindo que qualquer conta ou principal arbitrario assuma a role.
- A policy de permissoes (`data.aws_iam_policy_document.permissions`) usa as listas `allowed_actions` e `resource_arns` informadas pelo consumidor do modulo. Ambas as variaveis possuem `validation` que rejeita o wildcard total `"*"`, tanto em actions quanto em recursos, reduzindo o risco de permissoes administrativas ou excessivamente amplas. Recomenda-se que o consumidor informe apenas as actions e ARNs de recursos estritamente necessarios (principio do menor privilegio).
- Nenhum valor sensivel (chaves, segredos, credenciais) e usado ou exposto por este modulo.
- Tags sao aplicadas tanto na role quanto na policy via variavel `tags`, facilitando rastreabilidade e governanca.

## Uso

```
module "iam_role_with_policy" {
  source = "./"

  role_name   = "app-read-only-role"
  policy_name = "app-read-only-policy"

  trusted_principal_arn = "arn:aws:iam::123456789012:role/trusted-caller"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  resource_arns = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*",
  ]

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

## Variaveis principais

| Nome                     | Descricao                                                         | Obrigatoria |
|---------------------------|---------------------------------------------------------------------|-------------|
| `role_name`               | Nome da IAM Role                                                    | Sim         |
| `policy_name`              | Nome da IAM Policy                                                  | Sim         |
| `trusted_principal_arn`   | ARN do principal autorizado a assumir a role (sem wildcard)         | Sim         |
| `allowed_actions`         | Actions permitidas pela policy (sem wildcard total)                  | Nao (default: leitura S3) |
| `resource_arns`           | Recursos aos quais as actions se aplicam (sem wildcard total)        | Sim         |
| `tags`                    | Tags aplicadas a role e a policy                                     | Nao         |
| `max_session_duration`    | Duracao maxima da sessao assumida (segundos, entre 3600 e 43200)     | Nao         |

## Outputs principais

| Nome                    | Descricao                                 |
|--------------------------|---------------------------------------------|
| `role_arn`               | ARN da IAM Role criada                      |
| `role_name`              | Nome da IAM Role criada                     |
| `policy_arn`             | ARN da IAM Policy criada                    |
| `policy_name`            | Nome da IAM Policy criada                   |
| `policy_attachment_id`   | ID do attachment entre policy e role        |

## Validacao

Este modulo pode ser validado sintaticamente sem credenciais reais da AWS:

```
terraform init -backend=false
terraform validate
```
