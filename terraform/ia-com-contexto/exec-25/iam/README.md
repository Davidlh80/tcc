# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template provisiona uma IAM Policy de menor privilegio anexada a uma IAM Role dedicada. A trust policy (assume role policy) da Role e restrita a um unico principal configuravel por variavel, sem uso de `Principal: "*"` ou `"AWS": "*"`. A policy permite apenas as acoes e recursos informados via variavel, com `Effect: Allow` restrito a esses valores, e bloqueia explicitamente a combinacao `Action: "*"` com `Resource: "*"` na mesma statement. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada. Os recursos seguem o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` e as tags obrigatorias da organizacao.

## 2. Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`             | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                             |
| `system`                  | `string`       | Sim         | Nome do sistema/produto, usado no padrao de nomenclatura.                                    |
| `region`                  | `string`       | Nao         | Regiao AWS de provisionamento. Padrao: `us-east-1`.                                          |
| `additional_tags`         | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                |
| `policy_name`             | `string`       | Sim         | Finalidade da IAM Policy/Role, usada como sufixo no nome (ex.: `readonly`).                  |
| `policy_description`      | `string`       | Nao         | Descricao da IAM Policy.                                                                      |
| `trusted_principal_arn`   | `string`       | Sim         | ARN do principal especifico autorizado a assumir a Role. Proibido `"*"`.                     |
| `allowed_actions`         | `list(string)` | Sim         | Acoes IAM permitidas na policy.                                                               |
| `allowed_resources`       | `list(string)` | Sim         | ARNs de recursos aos quais as acoes permitidas se aplicam.                                   |
| `max_session_duration`    | `number`       | Nao         | Duracao maxima, em segundos, da sessao assumida via a Role (3600-43200). Padrao: `3600`.      |

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
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  trusted_principal_arn = "arn:aws:iam::123456789012:role/dev-tcc-app-runtime"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*",
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
