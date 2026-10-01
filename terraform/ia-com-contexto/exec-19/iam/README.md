# IAM Policy anexada a IAM Role

## Visao geral

Este template provisiona uma IAM Policy e uma IAM Role na AWS, anexando a policy diretamente a role (a policy nunca permanece solta, sem principal associado). A trust policy (assume role policy) da role e restrita a um unico principal configuravel via variavel, sem uso de `Principal: "*"` ou `"AWS": "*"`. A policy permite apenas as acoes e recursos informados por variavel (`Effect: Allow` restrito), e e proibida qualquer statement que combine `Action: "*"` com `Resource: "*"`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada. Os nomes dos recursos seguem o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` e todas as tags obrigatorias da organizacao sao aplicadas.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                               |
|--------------------------|----------------|-------------|-------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                         |
| `system`                 | `string`       | Sim         | Identificador do sistema dono do recurso, usado na nomenclatura padrao.                  |
| `region`                 | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                    |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.         |
| `policy_name`             | `string`       | Sim         | Finalidade/nome que identifica a IAM Policy e a IAM Role na nomenclatura padrao.          |
| `trusted_principal_arn`  | `string`       | Sim         | ARN do unico principal autorizado a assumir a IAM Role (trust policy). Sem wildcard.      |
| `allowed_actions`        | `list(string)` | Sim         | Lista de acoes IAM permitidas (`Effect: Allow`) na policy.                               |
| `allowed_resources`      | `list(string)` | Sim         | Lista de recursos (ARNs) aos quais as acoes permitidas se aplicam.                        |

## Outputs

| Nome          | Descricao                              |
|---------------|-----------------------------------------|
| `policy_name` | Nome da IAM Policy criada.              |
| `policy_arn`  | ARN da IAM Policy criada.               |
| `policy_id`   | ID da IAM Policy criada.                |
| `role_name`   | Nome da IAM Role criada.                |
| `role_arn`    | ARN da IAM Role criada.                 |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"

  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/dev-tcc-app-role"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*"
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
