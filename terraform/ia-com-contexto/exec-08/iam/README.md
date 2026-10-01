# IAM Policy anexada a uma IAM Role

## Visão geral

Este template provisiona uma IAM Policy e uma IAM Role na AWS, com a policy anexada à role por meio de um `aws_iam_role_policy_attachment` (a policy nunca fica solta, sem principal associado). A trust policy (assume role policy) da role é restrita a um único principal informado por variável, sem uso de `Principal: "*"` ou `"AWS": "*"`. A policy gerenciada permite apenas as ações e recursos informados por variável em uma única statement `Effect: Allow`, sendo proibida qualquer statement que combine `Action: "*"` com `Resource: "*"`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) é anexada ou replicada.

## Variáveis

| Nome                     | Tipo           | Obrigatória | Descrição                                                                                  |
|--------------------------|----------------|-------------|----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantação do recurso (`dev`, `hml` ou `prd`).                                 |
| `system`                 | `string`       | Sim         | Nome do sistema ou aplicação ao qual o recurso pertence.                                     |
| `region`                 | `string`       | Não         | Região AWS onde os recursos serão provisionados. Padrão: `us-east-1`.                        |
| `additional_tags`        | `map(string)`  | Não         | Tags adicionais mescladas às tags obrigatórias. Padrão: `{}`.                                |
| `policy_name`            | `string`       | Sim         | Finalidade da IAM Policy/Role, usada para compor o nome padronizado (ex.: `readonly`).       |
| `allowed_actions`        | `list(string)` | Sim         | Lista de IAM Actions permitidas na policy (statement `Effect: Allow`).                       |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs (ou `"*"`) de recursos permitidos na policy (statement `Effect: Allow`).        |
| `trusted_principal_arn`  | `string`       | Sim         | ARN único do principal autorizado a assumir a IAM Role (trust policy).                       |

## Outputs

| Nome          | Descrição                              |
|---------------|------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.               |
| `policy_arn`  | ARN da IAM Policy criada.                |
| `policy_id`   | ID da IAM Policy criada.                 |
| `role_name`   | Nome da IAM Role criada.                 |
| `role_arn`    | ARN da IAM Role criada.                  |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./caminho/para/este/modulo"

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

  trusted_principal_arn = "arn:aws:iam::123456789012:role/dev-tcc-app-execution"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
