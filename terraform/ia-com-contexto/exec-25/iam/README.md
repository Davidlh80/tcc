# IAM Policy anexada a IAM Role

## Visao geral

Este template provisiona uma IAM Policy de minimo privilegio anexada a uma IAM Role dedicada. A policy nunca fica solta: ela e criada e imediatamente anexada a role por meio de `aws_iam_role_policy_attachment`. A trust policy (assume role policy) da role restringe a assuncao da role a um unico principal configuravel (`trusted_principal_arn`), proibindo `Principal: "*"` ou `"AWS": "*"`. A statement de permissoes aplica `Effect: Allow` restrito exclusivamente as actions e aos recursos informados por variavel, e um precondition de ciclo de vida bloqueia a combinacao `Action: "*"` com `Resource: "*"` na mesma statement. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este template.

Os nomes dos recursos seguem o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `dev-tcc-iam-policy-readonly` e `dev-tcc-iam-role-readonly`), e as tags obrigatorias da organizacao sao aplicadas automaticamente, mescladas com `additional_tags`.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                             |
| `system`                 | `string`       | Sim         | Nome do sistema/produto, usado na composicao do nome padronizado.                            |
| `region`                 | `string`       | Nao         | Regiao AWS de provisionamento. Padrao: `us-east-1`.                                           |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.              |
| `policy_name`             | `string`       | Sim         | Finalidade/nome usado na composicao do nome padronizado da policy e da role.                 |
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico do principal autorizado a assumir a role. Nao aceita `"*"`.                         |
| `allowed_actions`        | `list(string)` | Sim         | Lista de actions IAM permitidas (`Effect: Allow`) na policy.                                  |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs de recursos permitidos (`Effect: Allow`) na policy.                              |

## Outputs

| Nome          | Descricao                              |
|---------------|-----------------------------------------|
| `policy_name` | Nome da IAM Policy criada.              |
| `policy_arn`  | ARN da IAM Policy criada.               |
| `policy_id`   | ID da IAM Policy criada.                |
| `role_name`   | Nome da IAM Role criada.                |
| `role_arn`    | ARN da IAM Role criada.                 |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  trusted_principal_arn = "arn:aws:iam::123456789012:role/app-service-role"

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
