# IAM Role com IAM Policy anexada (minimo privilegio)

Blueprint Terraform independente, sem vinculo com padroes organizacionais especificos, que provisiona:

- Uma **IAM Role**, com trust policy (assume role) restrita a um principal de servico AWS configuravel e, opcionalmente, a contas AWS externas especificas (com suporte a `ExternalId`).
- Uma **IAM Policy** com acoes e recursos definidos explicitamente pelo consumidor do modulo (sem wildcard total `"*"` em actions ou resources).
- O **attachment** entre a policy e a role, garantindo que a policy nunca fique solta sem principal associado.

## Decisoes de seguranca adotadas

- Nenhum wildcard total (`"*"`) e aceito em `allowed_actions` ou `resource_arns`: as variaveis possuem validacao que bloqueia esse valor, forcando o consumidor a declarar explicitamente o que e permitido (minimo privilegio por padrao).
- O trust policy nao aceita `principals` do tipo `"*"` (nao ha suporte a esse caso no modulo); e obrigatorio informar um `trusted_service` valido (ex.: `ec2.amazonaws.com`, `lambda.amazonaws.com`).
- Confianca em contas externas (`trusted_account_ids`) e opcional (lista vazia por padrao) e pode ser reforcada com `external_id`, mitigando o problema do "confused deputy".
- `permissions_boundary_arn` permite reforcar um teto de permissoes adicional, mas nao e obrigatorio.
- Nenhum valor sensivel ou credencial e fixado no codigo; tudo o que e configuravel esta em `variables.tf`.

## Uso

```
module "iam_role_policy" {
  source = "./"

  role_name       = "app-example-role"
  policy_name     = "app-example-policy"
  trusted_service = "lambda.amazonaws.com"

  allowed_actions = [
    "s3:GetObject",
    "s3:PutObject"
  ]

  resource_arns = [
    "arn:aws:s3:::exemplo-bucket/*"
  ]

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

## Requisitos

- Terraform >= 1.5.0
- Provider `hashicorp/aws` >= 5.0, < 6.0

## Validacao local (sem credenciais reais)

```
terraform fmt
terraform init -backend=false
terraform validate
```

## Principais variaveis

| Nome                     | Obrigatoria | Descricao                                                                 |
|--------------------------|:-----------:|----------------------------------------------------------------------------|
| `role_name`              | Sim         | Nome da IAM Role.                                                          |
| `policy_name`            | Sim         | Nome da IAM Policy.                                                        |
| `allowed_actions`        | Sim         | Lista explicita de actions permitidas (sem `"*"`).                        |
| `resource_arns`          | Sim         | Lista explicita de ARNs alvo (sem `"*"`).                                  |
| `trusted_service`        | Nao         | Principal de servico que pode assumir a role (default `ec2.amazonaws.com`).|
| `trusted_account_ids`    | Nao         | Contas AWS externas autorizadas a assumir a role via root principal.       |
| `external_id`            | Nao         | External ID exigido para os principals de conta externa.                  |
| `permissions_boundary_arn` | Nao       | ARN de policy usada como permissions boundary.                            |
| `tags`                   | Nao         | Tags aplicadas a role e a policy.                                          |

## Principais outputs

| Nome                     | Descricao                                          |
|--------------------------|-----------------------------------------------------|
| `role_arn`               | ARN da IAM Role criada.                             |
| `role_name`              | Nome da IAM Role criada.                            |
| `policy_arn`             | ARN da IAM Policy criada e anexada.                 |
| `assume_role_policy_json`| JSON da trust policy renderizada para a role.       |
