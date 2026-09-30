# IAM Policy anexada a IAM Role

## Visao geral

Este template provisiona uma IAM Policy customizada e uma IAM Role dedicada, anexando a policy a role por meio de `aws_iam_role_policy_attachment` — a policy nunca fica solta, sem nenhum principal associado.

A trust policy (assume role policy) da IAM Role e restrita a um principal especifico, configurado por variavel (tipo `AWS` ou `Service`), sendo proibido o uso de `Principal: "*"` ou `"AWS": "*"`.

A statement de permissao da policy aplica `Effect: Allow` restrito apenas as acoes e recursos informados por variavel, sendo proibida qualquer combinacao de `Action: "*"` com `Resource: "*"` na mesma statement (validado via bloco `check`). Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este template.

Os nomes dos recursos seguem o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo `dev-tcc-iam-policy-readonly` e `dev-tcc-iam-role-readonly`. Todos os recursos suportados recebem as tags obrigatorias `Project`, `Environment`, `ManagedBy`, `Owner` e `CostCenter`, mescladas com tags adicionais opcionais.

## Variaveis

| Nome                              | Tipo           | Obrigatoria | Descricao                                                                                                   |
|-----------------------------------|----------------|-------------|---------------------------------------------------------------------------------------------------------------|
| `environment`                     | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                              |
| `system`                          | `string`       | Sim         | Nome do sistema/aplicacao, usado na composicao do nome padronizado.                                           |
| `region`                          | `string`       | Sim         | Regiao AWS onde os recursos serao provisionados.                                                              |
| `additional_tags`                 | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                                 |
| `policy_name`                     | `string`       | Sim         | Finalidade/nome da IAM Policy, usado na composicao do nome padronizado.                                       |
| `role_name`                       | `string`       | Sim         | Finalidade/nome da IAM Role, usado na composicao do nome padronizado.                                         |
| `policy_description`              | `string`       | Nao         | Descricao da IAM Policy criada.                                                                               |
| `trusted_principal_type`          | `string`       | Sim         | Tipo do principal de confianca da trust policy (`AWS` ou `Service`).                                          |
| `trusted_principal_identifiers`   | `list(string)` | Sim         | Identificadores do principal de confianca (ARN ou service principal). Nao aceita `"*"`.                       |
| `allowed_actions`                 | `list(string)` | Sim         | Acoes IAM permitidas (`Effect: Allow`) na policy.                                                             |
| `allowed_resources`               | `list(string)` | Sim         | Recursos/ARNs permitidos (`Effect: Allow`) na policy.                                                         |

## Outputs

| Nome          | Descricao                          |
|---------------|-------------------------------------|
| `policy_name` | Nome da IAM Policy criada.          |
| `policy_arn`  | ARN da IAM Policy criada.           |
| `policy_id`   | ID da IAM Policy criada.            |
| `role_name`   | Nome da IAM Role criada.            |
| `role_arn`    | ARN da IAM Role criada.             |
| `role_id`     | ID da IAM Role criada.              |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./iam"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"

  policy_name = "readonly"
  role_name   = "readonly"

  trusted_principal_type        = "AWS"
  trusted_principal_identifiers = ["arn:aws:iam::123456789012:role/dev-tcc-app-role"]

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*",
  ]

  additional_tags = {
    Squad = "seguranca"
  }
}
```
