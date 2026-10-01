# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template cria uma IAM Policy de menor privilegio e uma IAM Role dedicada, anexando a policy a role por meio de `aws_iam_role_policy_attachment` (a policy nunca fica solta, sem principal associado).

Principais garantias de seguranca:

- A trust policy (assume role policy) da Role restringe `sts:AssumeRole` a um unico principal confiavel, definido pela variavel `trusted_principal_arn`. Nao e permitido `Principal: "*"` nem `"AWS": "*"`.
- A statement `Effect: Allow` da policy usa exclusivamente as actions e os resources informados pelas variaveis `allowed_actions` e `allowed_resources`.
- E proibido combinar `Action: "*"` com `Resource: "*"` na mesma statement (validado via `validation` cruzada entre variaveis).
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- Nomenclatura e tags seguem o padrao organizacional: `<ambiente>-<sistema>-<recurso>-<finalidade>` e as tags obrigatorias (`Project`, `Environment`, `ManagedBy`, `Owner`, `CostCenter`).

## 2. Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                               |
| `system`                 | `string`       | Sim         | Nome do sistema ou produto ao qual o recurso pertence.                                        |
| `region`                 | `string`       | Nao         | Regiao AWS onde os recursos serao criados. Padrao: `us-east-1`.                               |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.                              |
| `policy_name`            | `string`       | Sim         | Finalidade da IAM Policy/Role, usada na composicao do nome padronizado (ex.: `readonly`).      |
| `allowed_actions`        | `list(string)` | Sim         | Lista de IAM Actions permitidas na statement `Allow` da policy.                               |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs de recursos permitidos na statement `Allow` da policy.                          |
| `trusted_principal_arn`  | `string`       | Sim         | ARN do unico principal autorizado a assumir a Role via `sts:AssumeRole`.                      |

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
  source = "./iam"

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

  trusted_principal_arn = "arn:aws:iam::123456789012:role/dev-tcc-app-role"

  additional_tags = {
    Team = "plataforma"
  }
}
```
