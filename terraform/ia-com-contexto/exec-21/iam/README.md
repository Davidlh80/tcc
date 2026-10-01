# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template cria uma IAM Policy de menor privilegio e uma IAM Role dedicada, anexando a policy a role por meio de `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela sempre possui um principal associado atraves da role.

Principais garantias de seguranca aplicadas:

- A trust policy (assume role policy) da role e restrita a um unico principal, definido pela variavel `trusted_principal_arn`. Nao e permitido `Principal: "*"` nem `"AWS": "*"`.
- A statement da policy com `Effect: Allow` e restrita exatamente as actions e aos recursos informados pelas variaveis `allowed_actions` e `allowed_resources`.
- E proibida a combinacao de `Action: "*"` com `Resource: "*"` na mesma statement, validada via `precondition` no recurso `aws_iam_policy`.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- Nomenclatura e tags seguem o padrao organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>`.

## 2. Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                     |
|--------------------------|----------------|-------------|-------------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                |
| `system`                 | `string`       | Sim         | Nome do sistema/produto, usado na nomenclatura padronizada.                                     |
| `region`                 | `string`       | Nao         | Regiao AWS onde os recursos serao criados. Padrao: `us-east-1`.                                 |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias do padrao organizacional. Padrao: `{}`.       |
| `policy_name`            | `string`       | Sim         | Finalidade da IAM Policy/Role, usada na nomenclatura (`<ambiente>-<sistema>-iam-<finalidade>`). |
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico do principal autorizado a assumir a role via trust policy. Nao aceita `"*"`.           |
| `allowed_actions`        | `list(string)` | Sim         | Lista de IAM Actions permitidas na policy (`Effect: Allow`).                                     |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs de recursos permitidos na policy (`Effect: Allow`).                                |
| `max_session_duration`   | `number`       | Nao         | Duracao maxima, em segundos, da sessao assumida via a role. Padrao: `3600`.                      |

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

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"

  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/dev-tcc-app-execucao"

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
