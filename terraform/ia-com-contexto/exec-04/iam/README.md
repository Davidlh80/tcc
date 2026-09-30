# IAM Policy anexada a IAM Role

## 1. Visao geral do recurso

Este modulo Terraform provisiona uma IAM Policy customizada e uma IAM Role dedicada, anexando a policy a role (nenhum dos dois recursos fica orfao). A trust policy (assume role policy) da role restringe o principal autorizado a assumir a role a um unico ARN configuravel por variavel, sendo proibido o uso de `"*"` como principal. A policy customizada permite apenas as actions e recursos informados via variavel, sendo proibida qualquer statement que combine `Action: "*"` com `Resource: "*"`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este modulo.

Recursos criados:

- `aws_iam_policy.this`: policy customizada com o statement `Allow` restrito.
- `aws_iam_role.this`: role com trust policy restrita a um principal especifico.
- `aws_iam_role_policy_attachment.this`: anexa a policy a role.

Nomenclatura dos recursos segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`:

- Policy: `<environment>-<system>-iam-policy-<policy_name>`
- Role: `<environment>-<system>-iam-role-<policy_name>`

## 2. Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                     |
|--------------------------|----------------|-------------|------------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao. Valores permitidos: `dev`, `hml`, `prd`.                              |
| `system`                 | `string`       | Sim         | Nome do sistema/aplicacao proprietaria do recurso, usado na nomenclatura padronizada.           |
| `region`                 | `string`       | Sim         | Regiao AWS onde os recursos IAM serao provisionados.                                            |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                |
| `policy_name`            | `string`       | Sim         | Finalidade/identificador da policy IAM, usado para compor o nome da policy e da role.           |
| `allowed_actions`        | `list(string)` | Sim         | Lista de actions IAM permitidas (Effect Allow) na policy.                                       |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs de recursos aos quais as actions permitidas se aplicam.                           |
| `trusted_principal_arn`  | `string`       | Sim         | ARN do principal autorizado a assumir a role via `sts:AssumeRole`. Nao pode ser `"*"`.           |

## 3. Outputs

| Nome          | Descricao                                                  |
|---------------|-------------------------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                                   |
| `policy_arn`  | ARN da IAM Policy criada.                                    |
| `policy_id`   | ID da IAM Policy criada.                                     |
| `role_name`   | Nome da IAM Role criada e a qual a policy foi anexada.       |
| `role_arn`    | ARN da IAM Role criada.                                      |
| `role_id`     | Identificador unico (unique_id) da IAM Role criada.          |

## 4. Exemplo de uso

    module "iam_readonly" {
      source = "./caminho/para/este/modulo"

      environment = "prd"
      system      = "tcc"
      region      = "us-east-1"

      policy_name = "readonly"

      allowed_actions = [
        "s3:GetObject",
        "s3:ListBucket"
      ]

      allowed_resources = [
        "arn:aws:s3:::prd-tcc-s3-logs",
        "arn:aws:s3:::prd-tcc-s3-logs/*"
      ]

      trusted_principal_arn = "arn:aws:iam::123456789012:role/prd-tcc-app-role"

      additional_tags = {
        Team = "platform"
      }
    }

    output "policy_arn" {
      value = module.iam_readonly.policy_arn
    }
