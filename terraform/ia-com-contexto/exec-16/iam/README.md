# IAM Policy anexada a IAM Role

## Visao geral

Este template provisiona uma IAM Policy customizada e uma IAM Role, com a policy anexada diretamente a role (nenhuma policy fica solta, sem principal associado). A trust policy (assume role policy) da role e restrita a um unico principal configuravel por variavel, sendo proibido o uso de `Principal: "*"` ou `"AWS": "*"`. A policy segue o principio do menor privilegio: a statement `Effect: Allow` e restrita apenas as acoes e recursos informados por variavel, e e proibida qualquer statement que combine `Action: "*"` com `Resource: "*"`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada. Os nomes dos recursos seguem o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` e todas as tags obrigatorias da organizacao sao aplicadas.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|:-----------:|-----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                               |
| `system`                 | `string`       | Sim         | Nome do sistema/aplicacao, usado na nomenclatura padronizada.                                  |
| `region`                 | `string`       | Sim         | Regiao AWS onde os recursos serao provisionados.                                               |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                |
| `policy_name`            | `string`       | Sim         | Finalidade da policy/role, usada na composicao do nome padronizado (ex.: `readonly`).           |
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico do principal autorizado a assumir a Role na trust policy. Nao pode ser `"*"`.          |
| `allowed_actions`        | `list(string)` | Sim         | Lista de acoes IAM permitidas na statement `Allow` da policy.                                  |
| `allowed_resources`      | `list(string)` | Sim         | Lista de recursos (ARNs) permitidos na statement `Allow` da policy.                             |

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

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/ci-cd-deployer"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::prd-tcc-s3-logs",
    "arn:aws:s3:::prd-tcc-s3-logs/*"
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
