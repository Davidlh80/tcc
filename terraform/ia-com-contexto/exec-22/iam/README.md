# dev-tcc-iam-<finalidade>

## 1. Visao geral

Este template provisiona uma IAM Policy e a IAM Role a qual ela e anexada, seguindo o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` da organizacao.

Caracteristicas principais:

- A IAM Policy nunca fica solta: ela e criada e anexada a uma IAM Role via `aws_iam_role_policy_attachment`.
- A trust policy (assume role policy) da role restringe o principal autorizado a assumir a role a um unico ARN configuravel por variavel (`trusted_principal_arn`); nao e permitido `"AWS": "*"`.
- A policy possui uma unica statement com `Effect: Allow`, cujas `actions` e `resources` vem exclusivamente das variaveis `policy_actions` e `policy_resources`.
- E proibida a combinacao `Action: "*"` com `Resource: "*"` na mesma statement; essa regra e validada via `precondition` no recurso `aws_iam_policy`.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- Todas as tags obrigatorias da organizacao (`Project`, `Environment`, `ManagedBy`, `Owner`, `CostCenter`) sao aplicadas, podendo ser estendidas via `additional_tags`.

## 2. Variaveis

| Nome                      | Tipo           | Obrigatoria | Descricao                                                                                          |
|---------------------------|----------------|-------------|------------------------------------------------------------------------------------------------------|
| `environment`             | `string`       | Sim         | Ambiente de implantacao do recurso (`dev`, `hml` ou `prd`).                                          |
| `system`                  | `string`       | Sim         | Nome do sistema/aplicacao dono do recurso, usado no padrao de nomenclatura.                          |
| `region`                  | `string`       | Nao         | Regiao AWS utilizada pelo provider. Padrao: `us-east-1`.                                             |
| `additional_tags`         | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                        |
| `policy_name`             | `string`       | Sim         | Finalidade da IAM Policy/Role, usada como sufixo no padrao de nomenclatura.                          |
| `trusted_principal_arn`   | `string`       | Sim         | ARN do principal IAM (root, usuario ou role) autorizado a assumir a role. Nao pode ser `"*"`.        |
| `policy_actions`          | `list(string)` | Sim         | Lista de actions IAM permitidas (`Effect: Allow`) na policy.                                         |
| `policy_resources`        | `list(string)` | Sim         | Lista de ARNs de recursos permitidos (`Effect: Allow`) na policy.                                    |

## 3. Outputs

| Nome          | Descricao                                          |
|---------------|-----------------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                          |
| `policy_arn`  | ARN da IAM Policy criada.                           |
| `policy_id`   | ID da IAM Policy criada.                            |
| `role_name`   | Nome da IAM Role criada e associada a policy.       |
| `role_arn`    | ARN da IAM Role criada e associada a policy.        |
| `role_id`     | ID da IAM Role criada e associada a policy.         |

## 4. Exemplo de uso

    module "iam_readonly" {
      source = "./caminho/para/este/modulo"

      environment = "dev"
      system      = "tcc"
      region      = "us-east-1"
      policy_name = "readonly"

      trusted_principal_arn = "arn:aws:iam::123456789012:role/app-role"

      policy_actions = [
        "s3:GetObject",
        "s3:ListBucket",
      ]

      policy_resources = [
        "arn:aws:s3:::dev-tcc-s3-logs",
        "arn:aws:s3:::dev-tcc-s3-logs/*",
      ]

      additional_tags = {
        Team = "plataforma"
      }
    }
