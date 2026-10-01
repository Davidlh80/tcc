# IAM Policy anexada a IAM Role

## Visao geral

Este template provisiona uma IAM Policy de minimo privilegio e uma IAM Role dedicada, anexando a policy a role via `aws_iam_role_policy_attachment`. A policy nao fica solta: ela e sempre associada a um principal (a role criada por este modulo).

A trust policy (assume role policy) da role e restrita a lista de principals informada em `trusted_principal_arns`, sendo proibido o uso de `"*"` como principal. A policy criada nao permite a combinacao de `Action: "*"` com `Resource: "*"` na mesma statement, e o `Effect: Allow` e restrito exclusivamente as acoes e recursos informados via variavel. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este modulo.

Os recursos seguem o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` e recebem as tags obrigatorias da organizacao (`Project`, `Environment`, `ManagedBy`, `Owner`, `CostCenter`), mescladas com `additional_tags`.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|:-----------:|-----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                 | `string`       | Sim         | Nome curto do sistema/aplicacao, usado na nomenclatura padronizada.                            |
| `region`                 | `string`       | Sim         | Regiao AWS onde os recursos serao provisionados.                                              |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.                              |
| `policy_name`            | `string`       | Sim         | Finalidade da IAM Policy, usada na composicao do nome padronizado.                             |
| `policy_description`     | `string`       | Nao         | Descricao da IAM Policy.                                                                       |
| `policy_path`            | `string`       | Nao         | Path da IAM Policy no IAM. Padrao: `/`.                                                        |
| `role_purpose`           | `string`       | Sim         | Finalidade da IAM Role, usada na composicao do nome padronizado.                               |
| `role_description`       | `string`       | Nao         | Descricao da IAM Role.                                                                          |
| `role_path`              | `string`       | Nao         | Path da IAM Role no IAM. Padrao: `/`.                                                          |
| `max_session_duration`   | `number`       | Nao         | Duracao maxima da sessao assumida (segundos). Padrao: `3600`.                                  |
| `trusted_principal_arns` | `list(string)` | Sim         | ARNs dos principals autorizados a assumir a role (trust policy). Proibido conter `"*"`.        |
| `allowed_actions`        | `list(string)` | Sim         | Acoes IAM permitidas (`Effect: Allow`) na policy.                                              |
| `allowed_resources`      | `list(string)` | Sim         | Recursos aos quais as `allowed_actions` se aplicam.                                            |

## Outputs

| Nome           | Descricao                                    |
|----------------|-----------------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.                    |
| `policy_arn`   | ARN da IAM Policy criada.                     |
| `policy_id`    | ID da IAM Policy criada.                      |
| `role_name`    | Nome da IAM Role criada.                      |
| `role_arn`     | ARN da IAM Role criada.                       |
| `role_id`      | ID unico (unique_id) da IAM Role criada.       |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./iam"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"

  policy_name  = "readonly"
  role_purpose = "readonly"

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/app-servico-dev"
  ]

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
