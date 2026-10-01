# IAM Policy anexada a uma IAM Role

## Visao geral

Este modulo Terraform provisiona uma IAM Policy customizada e uma IAM Role, anexando a policy diretamente a role (nenhum dos dois recursos fica solto). A trust policy (assume role policy) da role e restrita a um unico principal configuravel por variavel, sem uso de `Principal: "*"` ou `"AWS": "*"`. A policy customizada permite apenas as acoes e recursos informados por variavel, com `Effect: Allow`, e proibe explicitamente a combinacao `Action: "*"` com `Resource: "*"` na mesma statement. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada. Os nomes dos recursos seguem o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` e todas as tags obrigatorias da organizacao sao aplicadas.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|:-----------:|-----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                               |
| `system`                 | `string`       | Sim         | Nome curto do sistema/projeto, usado na composicao do nome padronizado.                        |
| `region`                 | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                          |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                |
| `policy_name`            | `string`       | Sim         | Finalidade da IAM Policy/Role, usada na composicao do nome padronizado (ex.: `readonly`).       |
| `policy_description`     | `string`       | Nao         | Descricao da IAM Policy criada.                                                                |
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico do principal autorizado a assumir a Role (trust policy). Nao pode ser curinga.        |
| `allowed_actions`        | `list(string)` | Sim         | Acoes IAM permitidas (`Effect: Allow`) na policy customizada.                                  |
| `allowed_resources`      | `list(string)` | Sim         | ARNs de recursos permitidos (`Effect: Allow`) na policy customizada.                            |

## Outputs

| Nome          | Descricao                                        |
|---------------|---------------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                         |
| `policy_arn`  | ARN da IAM Policy criada.                          |
| `policy_id`   | ID da IAM Policy criada.                           |
| `role_name`   | Nome da IAM Role criada e com a policy anexada.    |
| `role_arn`    | ARN da IAM Role criada e com a policy anexada.     |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name            = "readonly"
  policy_description     = "Permite leitura de objetos em um bucket especifico."
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
