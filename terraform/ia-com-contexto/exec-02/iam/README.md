# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template provisiona uma IAM Policy de menor privilegio anexada a uma IAM Role dedicada, seguindo os padroes de nomenclatura, tags e governanca da organizacao (`tcc-iac-ia`).

Caracteristicas principais:

- A IAM Policy contem uma unica statement `Effect = Allow`, restrita as acoes (`allowed_actions`) e aos recursos (`allowed_resources`) informados por variavel.
- E proibida, por validacao em tempo de plano/apply, a combinacao de `Action = "*"` com `Resource = "*"` na mesma statement.
- A IAM Role possui trust policy (assume role policy) restrita a um unico principal configuravel (`trusted_principal_arn`), sendo proibido `Principal = "*"` ou `"AWS": "*"`.
- A policy nao fica solta: e anexada a role via `aws_iam_role_policy_attachment`.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- Nomenclatura padronizada: `<ambiente>-<sistema>-iam-<policy_name>-policy` e `<ambiente>-<sistema>-iam-<policy_name>-role`.
- Tags obrigatorias da organizacao aplicadas em todos os recursos que suportam tags.

## 2. Variaveis

| Nome                     | Tipo         | Obrigatoria | Descricao                                                                                   |
|--------------------------|--------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`            | string       | Sim         | Ambiente de implantacao (`dev`, `hml`, `prd`).                                                |
| `system`                 | string       | Sim         | Nome do sistema/aplicacao proprietario do recurso.                                            |
| `region`                 | string       | Sim         | Regiao AWS onde os recursos serao criados.                                                    |
| `additional_tags`        | map(string)  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.                              |
| `policy_name`            | string       | Sim         | Finalidade/identificador usado na nomenclatura padronizada da policy e da role.                |
| `trusted_principal_arn`  | string       | Sim         | ARN do principal autorizado a assumir a IAM Role. Nao pode ser `"*"`.                          |
| `allowed_actions`        | list(string) | Sim         | Lista de acoes IAM permitidas na statement `Allow` da policy.                                 |
| `allowed_resources`      | list(string) | Sim         | Lista de ARNs de recursos permitidos na statement `Allow` da policy.                           |

## 3. Outputs

| Nome          | Descricao                              |
|---------------|-----------------------------------------|
| `policy_name` | Nome da IAM Policy criada.              |
| `policy_arn`  | ARN da IAM Policy criada.               |
| `policy_id`   | ID da IAM Policy criada.                |
| `role_name`   | Nome da IAM Role criada.                |
| `role_arn`    | ARN da IAM Role criada.                 |
| `role_id`     | ID da IAM Role criada.                  |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./caminho/para/este/template"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/prd-tcc-ci-deployer"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::prd-tcc-s3-logs",
    "arn:aws:s3:::prd-tcc-s3-logs/*",
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
