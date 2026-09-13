# IAM Policy

## Visão geral

Este template Terraform provisiona uma IAM Policy customizada seguindo o princípio do menor privilégio. A policy contém uma única statement com `Effect: Allow`, restrita exclusivamente às ações e recursos informados por variável. A combinação de `Action: "*"` com `Resource: "*"` na mesma statement é proibida por uma validação (`lifecycle.precondition`) aplicada no recurso, e nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) é anexada ou replicada por este template.

O nome do recurso segue o padrão organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo: `prd-tcc-iam-readonly`.

## Variáveis

| Nome                  | Tipo           | Obrigatória | Descrição                                                                 |
|-----------------------|----------------|-------------|----------------------------------------------------------------------------|
| `environment`         | `string`       | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                          |
| `system`              | `string`       | Sim         | Nome do sistema ou aplicação associada ao recurso.                       |
| `region`              | `string`       | Não         | Região AWS onde o provider será configurado. Padrão: `us-east-1`.        |
| `additional_tags`     | `map(string)`  | Não         | Tags adicionais mescladas às tags obrigatórias da organização.           |
| `policy_name`         | `string`       | Sim         | Finalidade da IAM Policy, usada para compor o nome padronizado.          |
| `policy_description`  | `string`       | Não         | Descrição da IAM Policy.                                                  |
| `allowed_actions`     | `list(string)` | Sim         | Lista de ações IAM permitidas na statement Allow.                        |
| `allowed_resources`   | `list(string)` | Sim         | Lista de ARNs de recursos permitidos na statement Allow.                 |

## Outputs

| Nome           | Descrição                          |
|----------------|-------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.          |
| `policy_arn`   | ARN da IAM Policy criada.           |
| `policy_id`    | ID da IAM Policy criada.            |

## Exemplo de uso

```hcl
module "iam_policy" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name        = "readonly"
  policy_description = "Acesso somente leitura a objetos de um bucket específico"

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
