# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template cria uma IAM Policy de menor privilegio e uma IAM Role dedicada, anexando a policy a role por meio de `aws_iam_role_policy_attachment`. A policy nao fica solta: ela esta sempre vinculada a um principal (a role criada).

A trust policy (assume role policy) da role restringe o principal autorizado a assumir a role a um unico ARN configuravel via `trusted_principal_arn`, sendo proibido o uso de `"*"` como principal.

A statement `Allow` da policy e restrita exclusivamente as actions e aos recursos informados pelas variaveis `allowed_actions` e `allowed_resources`. E proibida a combinacao de `Action: "*"` com `Resource: "*"` na mesma statement, validada em tempo de plano por meio de uma precondicao (`lifecycle.precondition`). Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este template.

Nomenclatura dos recursos, seguindo o padrao organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>`:

- IAM Policy: `<environment>-<system>-iam-policy-<policy_name>`
- IAM Role: `<environment>-<system>-iam-role-<policy_name>`

## 2. Variaveis

| Nome                     | Tipo         | Obrigatoria | Descricao                                                                                   |
|--------------------------|--------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`            | string       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                 | string       | Sim         | Nome curto do sistema/produto, usado no padrao de nomenclatura.                               |
| `region`                 | string       | Nao         | Regiao AWS onde os recursos serao criados. Padrao: `us-east-1`.                               |
| `additional_tags`        | map(string)  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.              |
| `policy_name`            | string       | Sim         | Finalidade da policy/role, usada no padrao de nomenclatura.                                   |
| `trusted_principal_arn`  | string       | Sim         | ARN unico do principal autorizado a assumir a role. Nao pode ser `"*"`.                       |
| `allowed_actions`        | list(string) | Sim         | Actions IAM permitidas na statement `Allow` da policy.                                        |
| `allowed_resources`      | list(string) | Sim         | Recursos (ARNs) permitidos na statement `Allow` da policy.                                    |

## 3. Outputs

| Nome          | Descricao                              |
|---------------|-----------------------------------------|
| `policy_name` | Nome da IAM Policy criada.              |
| `policy_arn`  | ARN da IAM Policy criada.               |
| `policy_id`   | ID da IAM Policy criada.                |
| `role_name`   | Nome da IAM Role criada.                |
| `role_arn`    | ARN da IAM Role criada.                 |

## 4. Exemplo de uso

    module "iam_readonly" {
      source = "./caminho/para/este/modulo"

      environment = "dev"
      system      = "tcc"
      region      = "us-east-1"

      policy_name            = "readonly"
      trusted_principal_arn  = "arn:aws:iam::123456789012:role/app-service-role"

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
