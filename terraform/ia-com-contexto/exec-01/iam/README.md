# IAM Policy anexada a uma IAM Role

## Visao geral

Este template provisiona uma IAM Policy de menor privilegio e uma IAM Role dedicada, anexando a policy diretamente a role (nenhuma policy fica solta, sem principal associado). A trust policy (assume role policy) da role e restrita a um unico principal, configuravel por variavel, sendo proibido o uso de `Principal: "*"` ou `"AWS": "*"`. A policy permite apenas as acoes e recursos informados por variavel em uma unica statement `Effect: Allow`, sendo proibida qualquer combinacao de `Action: "*"` com `Resource: "*"`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.

Nomenclatura dos recursos segue o padrao `<ambiente>-<sistema>-iam-<finalidade>` (ex.: `prd-tcc-iam-readonly` para a policy e `prd-tcc-iam-readonly-role` para a role, dependendo dos valores informados em `policy_name` e `role_name`).

## Variaveis

| Nome                    | Tipo           | Obrigatoria | Descricao                                                                                   |
|-------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`           | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                             |
| `system`                | `string`       | Nao         | Nome do sistema/aplicacao, usado na composicao do nome dos recursos. Padrao: `tcc`.          |
| `region`                | `string`       | Sim         | Regiao AWS onde os recursos serao provisionados.                                             |
| `additional_tags`       | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias da organizacao. Padrao: `{}`.                 |
| `policy_name`           | `string`       | Sim         | Finalidade da IAM Policy, usada na composicao do nome padrao.                                |
| `role_name`             | `string`       | Sim         | Finalidade da IAM Role, usada na composicao do nome padrao.                                  |
| `trusted_principal_arn` | `string`       | Sim         | ARN do principal especifico autorizado a assumir a role. Nao pode ser `"*"`.                 |
| `allowed_actions`       | `list(string)` | Sim         | Lista de acoes IAM permitidas na statement `Effect: Allow`.                                  |
| `allowed_resources`     | `list(string)` | Sim         | Lista de ARNs de recursos permitidos na statement `Effect: Allow`.                           |

## Outputs

| Nome           | Descricao                            |
|----------------|----------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.             |
| `policy_arn`   | ARN da IAM Policy criada.              |
| `policy_id`    | ID da IAM Policy criada.               |
| `role_name`    | Nome da IAM Role criada.               |
| `role_arn`     | ARN da IAM Role criada.                |
| `role_id`      | ID da IAM Role criada.                 |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./caminho/para/este/modulo"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name = "readonly"
  role_name   = "readonly-role"

  trusted_principal_arn = "arn:aws:iam::123456789012:role/plataforma-ci"

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
