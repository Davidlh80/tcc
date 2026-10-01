# IAM Policy anexada a IAM Role

## 1. Visao geral

Este modulo provisiona uma IAM Policy de menor privilegio e uma IAM Role dedicada, com a policy anexada via `aws_iam_role_policy_attachment` (a policy nunca fica solta, sem principal associado). A trust policy (assume role policy) da role e restrita a um unico principal configuravel por variavel, sem uso de `Principal: "*"` ou `"AWS": "*"`. A statement da policy e limitada ao `Effect: Allow` apenas para as acoes e recursos informados por variavel, com bloqueio explicito (via precondition) contra a combinacao `Action: "*"` e `Resource: "*"`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada. Os nomes seguem o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` e as tags obrigatorias da organizacao sao aplicadas em todos os recursos que suportam tags.

## 2. Variaveis

| Nome                    | Tipo           | Obrigatoria | Descricao                                                                                   |
|-------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`            | `string`        | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                 | `string`        | Sim         | Nome do sistema/aplicacao ao qual o recurso pertence.                                         |
| `region`                 | `string`        | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                         |
| `additional_tags`        | `map(string)`   | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                 |
| `policy_name`            | `string`        | Sim         | Finalidade da IAM Policy/Role, usada na nomenclatura padrao.                                  |
| `allowed_actions`        | `list(string)`  | Sim         | Lista de acoes IAM permitidas (Effect Allow) na policy.                                       |
| `allowed_resources`      | `list(string)`  | Sim         | Lista de ARNs de recursos aos quais a policy concede acesso.                                  |
| `trusted_principal_arn`  | `string`        | Sim         | ARN do principal autorizado a assumir a role via trust policy. Nao aceita `"*"`.               |

## 3. Outputs

| Nome          | Descricao                                          |
|---------------|-----------------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                           |
| `policy_arn`  | ARN da IAM Policy criada.                            |
| `policy_id`   | ID da IAM Policy criada.                             |
| `role_name`   | Nome da IAM Role criada e associada a policy.        |
| `role_arn`    | ARN da IAM Role criada e associada a policy.         |
| `role_id`     | ID da IAM Role criada e associada a policy.          |

## 4. Exemplo de uso

    module "iam_readonly" {
      source = "./modules/iam-role-policy"

      environment = "dev"
      system      = "tcc"
      region      = "us-east-1"
      policy_name = "readonly"

      trusted_principal_arn = "arn:aws:iam::123456789012:role/ci-deployer"

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
