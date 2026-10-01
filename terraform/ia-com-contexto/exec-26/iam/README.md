# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template cria uma IAM Policy de menor privilegio e uma IAM Role dedicada, anexando a policy a role por meio de `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela e sempre associada a um principal (a role criada por este modulo).

A trust policy (assume role policy) da role e restrita a um unico principal configuravel via `trusted_principal_arn`, sendo proibido o uso de `Principal: "*"` ou `"AWS": "*"`. A statement `Allow` da policy e restrita apenas as actions e recursos informados pelas variaveis `allowed_actions` e `allowed_resources`, sendo proibida a combinacao `Action: "*"` com `Resource: "*"`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este template.

Os nomes dos recursos seguem o padrao organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>` e todos os recursos recebem as tags obrigatorias da organizacao, mescladas com tags adicionais informadas pelo usuario.

## 2. Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                                   |
|--------------------------|----------------|-------------|---------------------------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                             |
| `system`                 | `string`       | Nao         | Nome do sistema/projeto usado na composicao do nome dos recursos. Padrao: `tcc`.                             |
| `region`                 | `string`       | Nao         | Regiao AWS onde os recursos IAM serao gerenciados. Padrao: `us-east-1`.                                      |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                             |
| `policy_name`            | `string`       | Sim         | Finalidade/sufixo que identifica a policy e a role (ex.: `readonly`, `deploy`).                              |
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico do principal autorizado a assumir a role (trust policy). Nao pode ser `*`.                         |
| `allowed_actions`        | `list(string)` | Sim         | Lista de actions IAM permitidas na statement `Allow` da policy.                                              |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs de recursos permitidos na statement `Allow` da policy.                                         |

## 3. Outputs

| Nome          | Descricao                              |
|---------------|------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.               |
| `policy_arn`  | ARN da IAM Policy criada.                |
| `policy_id`   | ID da IAM Policy criada.                 |
| `role_name`   | Nome da IAM Role criada.                 |
| `role_arn`    | ARN da IAM Role criada.                  |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment            = "dev"
  system                 = "tcc"
  region                 = "us-east-1"
  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/app-ci-cd"

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
