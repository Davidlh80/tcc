# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template provisiona uma IAM Policy customizada e uma IAM Role, anexando a policy a role (a policy nunca fica solta, sem principal associado). A trust policy (assume role policy) da role restringe o principal autorizado a assumi-la a ARNs informados por variavel, sem uso de `Principal: "*"` ou `"AWS": "*"`. A policy segue o principio do menor privilegio: contem uma unica statement `Effect: Allow` restrita as acoes e recursos informados por variavel, sem combinar `Action: "*"` com `Resource: "*"` na mesma statement, e nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.

Nomenclatura dos recursos segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`:

- IAM Policy: `<environment>-<system>-iam-policy-<policy_name>`
- IAM Role: `<environment>-<system>-iam-role-<policy_name>`

## 2. Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`             | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                  | `string`       | Sim         | Nome do sistema/projeto ao qual o recurso pertence.                                           |
| `region`                  | `string`       | Sim         | Regiao AWS onde os recursos serao provisionados.                                              |
| `additional_tags`         | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias do padrao organizacional. Padrao: `{}`.        |
| `policy_name`              | `string`       | Sim         | Finalidade da IAM Policy/Role, usada na composicao do nome padronizado (ex.: `readonly`).     |
| `policy_description`       | `string`       | Nao         | Descricao aplicada a IAM Policy e a IAM Role.                                                 |
| `allowed_actions`          | `list(string)` | Sim         | Acoes IAM permitidas (`Effect: Allow`) na policy anexada a role.                              |
| `allowed_resources`        | `list(string)` | Sim         | ARNs de recursos permitidos (`Effect: Allow`) na policy anexada a role.                       |
| `trusted_principal_arns`   | `list(string)` | Sim         | ARNs dos principals autorizados a assumir a role via trust policy. Nao pode conter `"*"`.     |
| `max_session_duration`     | `number`       | Nao         | Duracao maxima, em segundos, da sessao assumida pela role. Padrao: `3600`.                    |

## 3. Outputs

| Nome           | Descricao                                  |
|----------------|---------------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.                  |
| `policy_arn`   | ARN da IAM Policy criada.                   |
| `policy_id`    | ID da IAM Policy criada.                    |
| `role_name`    | Nome da IAM Role criada.                    |
| `role_arn`     | ARN da IAM Role criada.                     |
| `role_id`      | Unique ID da IAM Role criada.               |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*",
  ]

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/dev-tcc-ci-deployer",
  ]

  additional_tags = {
    Squad = "platform"
  }
}
```
