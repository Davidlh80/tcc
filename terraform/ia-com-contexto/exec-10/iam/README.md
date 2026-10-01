# IAM Policy anexada a IAM Role

## 1. Visao geral

Este modulo Terraform provisiona uma IAM Policy de minimo privilegio e uma IAM Role dedicada, anexando a policy diretamente a role (a policy nunca fica solta, sem nenhum principal associado). A trust policy (assume role policy) da role e restrita a um ou mais principals configuraveis via variavel, sendo proibido o uso de `Principal: "*"` ou `"AWS": "*"`. A policy permite apenas as acoes e recursos informados por variavel, sendo proibida qualquer statement que combine `Action: "*"` com `Resource: "*"`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este modulo. Os recursos seguem o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `prd-tcc-iam-readonly` para a policy e `prd-tcc-iam-role-readonly` para a role) e sao marcados com as tags obrigatorias da organizacao.

## 2. Variaveis

| Nome                      | Tipo           | Obrigatoria | Descricao                                                                                       |
|---------------------------|----------------|-------------|---------------------------------------------------------------------------------------------------|
| `environment`             | `string`       | Sim         | Ambiente de implantacao do recurso (`dev`, `hml` ou `prd`).                                       |
| `system`                  | `string`       | Nao         | Nome do sistema/projeto ao qual o recurso pertence. Padrao: `tcc`.                                |
| `region`                  | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                             |
| `additional_tags`         | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.                                 |
| `policy_name`              | `string`       | Sim         | Finalidade da policy/role IAM, usada para compor o nome padronizado do recurso (ex.: `readonly`). |
| `trusted_principal_arns`  | `list(string)` | Sim         | ARNs de principals autorizados a assumir a IAM Role. Nao aceita `"*"`.                             |
| `allowed_actions`         | `list(string)` | Sim         | Acoes IAM permitidas (`Effect: Allow`) na policy.                                                 |
| `allowed_resources`       | `list(string)` | Sim         | Recursos (ARNs) aos quais as acoes permitidas se aplicam.                                         |

## 3. Outputs

| Nome          | Descricao                          |
|---------------|-------------------------------------|
| `policy_name` | Nome da IAM Policy criada.          |
| `policy_arn`  | ARN da IAM Policy criada.           |
| `policy_id`   | ID da IAM Policy criada.            |
| `role_name`   | Nome da IAM Role criada.            |
| `role_arn`    | ARN da IAM Role criada.             |
| `role_id`     | ID da IAM Role criada.              |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./modulos/iam-policy-role"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/app-servico"
  ]

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::prd-tcc-s3-logs",
    "arn:aws:s3:::prd-tcc-s3-logs/*"
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
