# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template provisiona uma IAM Policy de menor privilegio e uma IAM Role dedicada, anexando a policy a role por meio de `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela e sempre associada a um principal (a role criada).

Principais garantias de seguranca aplicadas:

- A trust policy (assume role policy) da role restringe o principal autorizado a assumir a role a um unico ARN configuravel via `trusted_principal_arn`, sem permitir `"AWS": "*"`.
- A statement de permissoes da policy bloqueia, via `precondition` no recurso `aws_iam_policy`, a combinacao de `Action: "*"` com `Resource: "*"`.
- O `Effect: Allow` e restrito apenas as acoes (`allowed_actions`) e recursos (`allowed_resources`) informados por variavel.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada; apenas a policy customizada criada por este template e associada a role.
- Nomenclatura segue o padrao `<ambiente>-<sistema>-iam-<finalidade>`, com a role usando o sufixo adicional `-role`.
- Todas as tags obrigatorias da organizacao sao aplicadas automaticamente e podem ser complementadas via `additional_tags`.

## 2. Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                     |
|--------------------------|----------------|-------------|------------------------------------------------------------------------------------------------|
| `environment`             | `string`        | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                               |
| `system`                  | `string`        | Nao         | Nome do sistema/projeto usado no padrao de nomenclatura. Padrao: `tcc`.                        |
| `region`                  | `string`        | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                          |
| `additional_tags`         | `map(string)`   | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                  |
| `policy_name`              | `string`        | Sim         | Finalidade da policy/role, usada como sufixo no padrao `<ambiente>-<sistema>-iam-<finalidade>`. |
| `allowed_actions`         | `list(string)`  | Sim         | Lista de acoes IAM permitidas (`Effect: Allow`).                                               |
| `allowed_resources`       | `list(string)`  | Sim         | Lista de ARNs de recursos permitidos (`Effect: Allow`).                                        |
| `trusted_principal_arn`   | `string`        | Sim         | ARN do principal (conta, usuario ou role) autorizado a assumir a role. Nao aceita `"*"`.        |
| `max_session_duration`    | `number`        | Nao         | Duracao maxima, em segundos, da sessao assumida pela role (3600 a 43200). Padrao: `3600`.       |

## 3. Outputs

| Nome          | Descricao                                        |
|---------------|---------------------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.                         |
| `policy_arn`   | ARN da IAM Policy criada.                          |
| `policy_id`    | ID da IAM Policy criada.                           |
| `role_name`    | Nome da IAM Role criada, a qual a policy esta anexada. |
| `role_arn`     | ARN da IAM Role criada.                            |
| `role_id`      | ID unico da IAM Role criada.                       |

## 4. Exemplo de uso

module "iam_readonly" {
  source = "./caminho/para/este/modulo"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"
  policy_name  = "readonly"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::prd-tcc-s3-logs",
    "arn:aws:s3:::prd-tcc-s3-logs/*"
  ]

  trusted_principal_arn = "arn:aws:iam::123456789012:role/prd-tcc-ec2-app"

  additional_tags = {
    Squad = "plataforma"
  }
}
