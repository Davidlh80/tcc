# IAM Policy anexada a uma IAM Role

## Visao geral do recurso

Este modulo Terraform provisiona uma IAM Policy customizada e uma IAM Role dedicada, anexando a policy a role por meio de `aws_iam_role_policy_attachment`. A policy nunca fica solta (sem principal associado).

A trust policy (assume role policy) da role e restrita a um unico principal especifico, informado por variavel — nao e permitido `Principal: "*"` nem `"AWS": "*"`. A statement de permissoes segue o principio do menor privilegio: `Effect: Allow` restrito apenas as actions e resources informados por variavel, sendo proibida a combinacao `Action: "*"` com `Resource: "*"` na mesma statement (validada via `lifecycle.precondition`). Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.

Os recursos seguem o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `dev-tcc-iam-policy-readonly` e `dev-tcc-iam-role-readonly`) e recebem as tags obrigatorias da organizacao, mescladas com tags adicionais opcionais.

## Variaveis

| Nome                    | Tipo           | Obrigatoria | Descricao                                                                                   |
|-------------------------|----------------|:-----------:|-----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                 | `string`       | Nao         | Identificador do sistema/projeto usado na nomenclatura. Padrao: `tcc`.                        |
| `region`                 | `string`       | Nao         | Regiao AWS de provisionamento. Padrao: `us-east-1`.                                           |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                 |
| `policy_name`            | `string`       | Sim         | Finalidade da IAM Policy/Role, usada na nomenclatura padronizada.                              |
| `policy_description`     | `string`       | Nao         | Descricao funcional da IAM Policy.                                                            |
| `trusted_principal_arn`  | `string`       | Sim         | ARN especifico (role, user ou root) autorizado a assumir a role. Proibido `"*"`.               |
| `allowed_actions`        | `list(string)` | Sim         | Lista de IAM Actions permitidas na policy (menor privilegio).                                 |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs de recursos permitidos na policy (menor privilegio).                             |
| `max_session_duration`   | `number`       | Nao         | Duracao maxima da sessao assumida, em segundos (3600 a 43200). Padrao: `3600`.                |

## Outputs

| Nome                        | Descricao                                                        |
|-----------------------------|--------------------------------------------------------------------|
| `policy_name`                | Nome da IAM Policy criada.                                         |
| `policy_arn`                 | ARN da IAM Policy criada.                                          |
| `policy_id`                  | ID da IAM Policy criada.                                           |
| `role_name`                  | Nome da IAM Role criada.                                           |
| `role_arn`                   | ARN da IAM Role criada.                                            |
| `role_id`                    | Unique ID da IAM Role criada.                                      |
| `role_policy_attachment_id`  | ID do vinculo entre a IAM Role e a IAM Policy.                     |

## Exemplo de uso

    module "iam_readonly" {
      source = "./iam"

      environment = "dev"
      system      = "tcc"
      region      = "us-east-1"
      policy_name = "readonly"

      trusted_principal_arn = "arn:aws:iam::123456789012:role/ci-cd-deployer"

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
