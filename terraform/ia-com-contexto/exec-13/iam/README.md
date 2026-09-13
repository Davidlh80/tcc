# IAM Policy — Blueprint Terraform

## 1. Visao geral

Este modulo cria uma IAM Policy seguindo o padrao organizacional de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `dev-tcc-iam-readonly`).

A policy contem uma unica statement com `Effect: Allow`, restrita exclusivamente as actions e aos resources informados por variavel. E proibido combinar `Action: "*"` com `Resource: "*"` na mesma statement, validacao aplicada tanto em `variables.tf` quanto em uma precondition no recurso. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este modulo.

## 2. Variaveis

| Nome                  | Tipo           | Obrigatoria | Descricao                                                                 |
|-----------------------|----------------|:-----------:|----------------------------------------------------------------------------|
| `environment`          | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                            |
| `system`               | `string`       | Sim         | Nome do sistema/produto, usado na nomenclatura padronizada.                 |
| `region`               | `string`       | Nao         | Regiao AWS. Padrao: `us-east-1`.                                            |
| `additional_tags`      | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.               |
| `policy_name`          | `string`       | Sim         | Finalidade da policy, usada para compor o nome padronizado.                 |
| `policy_description`   | `string`       | Nao         | Descricao funcional da policy.                                             |
| `allowed_actions`      | `list(string)` | Sim         | Lista de actions permitidas na statement Allow.                            |
| `allowed_resources`    | `list(string)` | Sim         | Lista de ARNs de recursos permitidos na statement Allow.                    |

## 3. Outputs

| Nome           | Descricao                             |
|----------------|-----------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.               |
| `policy_arn`   | ARN da IAM Policy criada.                |
| `policy_id`    | ID da IAM Policy criada.                 |

## 4. Exemplo de uso

```hcl
module "iam_policy_readonly" {
  source = "./iam"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  policy_description = "Acesso somente leitura ao bucket de logs."

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
