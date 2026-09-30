# IAM Policy anexada a IAM Role

## Visao geral do recurso

Este template provisiona uma IAM Policy de minimo privilegio anexada a uma IAM Role dedicada, seguindo o padrao organizacional de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>`.

O template cria:

- uma IAM Policy cujas permissoes (`Effect = Allow`) ficam restritas exatamente as acoes e aos recursos informados por variavel, sem permitir a combinacao de `Action = "*"` com `Resource = "*"` na mesma statement;
- uma IAM Role com trust policy (assume role policy) restrita a um principal especifico, configuravel por variavel, sem permitir `Principal = "*"` nem `"AWS": "*"`;
- o anexo (`aws_iam_role_policy_attachment`) da policy criada a role criada, garantindo que a policy nunca fique solta, sem principal associado;
- nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.

Validacoes automaticas (`lifecycle.precondition`) impedem, no `terraform plan/apply`, a criacao de uma trust policy com principal `"*"` ou de uma statement que combine `Action = "*"` com `Resource = "*"`.

## Variaveis

| Nome                             | Tipo           | Obrigatoria | Descricao                                                                                     |
|-----------------------------------|----------------|-------------|-------------------------------------------------------------------------------------------------|
| `environment`                     | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                               |
| `system`                          | `string`       | Sim         | Identificador do sistema/projeto, usado na composicao do nome.                                 |
| `region`                          | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                          |
| `additional_tags`                 | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias do padrao organizacional. Padrao: `{}`.     |
| `policy_name`                     | `string`       | Sim         | Finalidade da IAM Policy/Role, usada na composicao do nome dos recursos (ex.: `readonly`).     |
| `policy_description`              | `string`       | Nao         | Descricao customizada da IAM Policy. Padrao: descricao gerada automaticamente.                 |
| `role_description`                | `string`       | Nao         | Descricao customizada da IAM Role. Padrao: descricao gerada automaticamente.                   |
| `allowed_actions`                 | `list(string)` | Sim         | Lista de acoes IAM permitidas na statement `Effect = Allow` da policy.                         |
| `allowed_resources`               | `list(string)` | Sim         | Lista de ARNs de recursos aos quais as acoes permitidas se aplicam.                             |
| `trusted_principal_type`          | `string`       | Nao         | Tipo do principal confiavel na trust policy (`AWS` ou `Service`). Padrao: `AWS`.                |
| `trusted_principal_identifiers`   | `list(string)` | Sim         | Identificadores do principal confiavel autorizado a assumir a role. Nao pode conter `"*"`.     |
| `max_session_duration`            | `number`       | Nao         | Duracao maxima, em segundos, de uma sessao assumida da role (3600 a 43200). Padrao: `3600`.    |

## Outputs

| Nome          | Descricao                                                |
|----------------|-----------------------------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.                                |
| `policy_arn`   | ARN da IAM Policy criada.                                  |
| `policy_id`    | ID da IAM Policy criada.                                   |
| `role_name`    | Nome da IAM Role criada e vinculada a policy.              |
| `role_arn`     | ARN da IAM Role criada e vinculada a policy.                |
| `role_id`      | ID unico da IAM Role criada.                                |

## Exemplo de uso

```hcl
module "iam_readonly_role" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::prd-tcc-s3-logs",
    "arn:aws:s3:::prd-tcc-s3-logs/*",
  ]

  trusted_principal_type = "AWS"
  trusted_principal_identifiers = [
    "arn:aws:iam::123456789012:role/prd-tcc-iam-deploy",
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
