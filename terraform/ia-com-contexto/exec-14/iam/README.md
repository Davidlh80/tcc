# IAM Policy — dev-tcc-iam-\<finalidade\>

## 1. Visão geral

Este blueprint provisiona uma IAM Policy da AWS seguindo os padrões organizacionais de nomenclatura, tags e segurança.

A policy é construída a partir de uma única statement `Allow`, restrita exclusivamente às ações e recursos informados via variável. A combinação de `Action: "*"` com `Resource: "*"` é proibida e validada em tempo de `plan`/`apply` através de uma `precondition`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) é anexada ou replicada por este blueprint.

O nome do recurso segue o padrão `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo: `prd-tcc-iam-readonly`.

## 2. Variáveis

| Nome                  | Tipo           | Obrigatória | Descrição                                                                                          |
|-----------------------|----------------|-------------|------------------------------------------------------------------------------------------------------|
| `environment`         | `string`       | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                                    |
| `system`               | `string`       | Sim         | Nome do sistema/aplicação, usado na padronização de nomenclatura.                                   |
| `region`               | `string`       | Sim         | Região AWS onde os recursos serão provisionados.                                                    |
| `policy_name`          | `string`       | Sim         | Finalidade da policy, usada como sufixo do nome padronizado (ex.: `readonly`, `deploy`).             |
| `policy_description`   | `string`       | Não         | Descrição da IAM Policy. Padrão: policy gerenciada via Terraform seguindo o menor privilégio.        |
| `allowed_actions`      | `list(string)` | Sim         | Ações IAM permitidas na statement `Allow`. Não pode ser `["*"]` combinada com `allowed_resources = ["*"]`. |
| `allowed_resources`    | `list(string)` | Sim         | ARNs de recursos permitidos na statement `Allow`. Não pode ser `["*"]` combinada com `allowed_actions = ["*"]`. |
| `additional_tags`      | `map(string)`  | Não         | Tags adicionais mescladas às tags obrigatórias da organização. Padrão: `{}`.                        |

## 3. Outputs

| Nome           | Descrição                                             |
|----------------|--------------------------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.                             |
| `policy_arn`   | ARN da IAM Policy criada.                              |
| `policy_id`    | ID da IAM Policy criada.                               |

## 4. Exemplo de uso

```hcl
module "iam_policy_readonly" {
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

  additional_tags = {
    Squad = "plataforma"
  }
}
```
