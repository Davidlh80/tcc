# dev-tcc-iam-policy-<policy_name> / dev-tcc-iam-role-<policy_name>

## Visao geral

Este template cria uma IAM Policy de minimo privilegio anexada a uma IAM Role dedicada, seguindo o padrao organizacional `tcc-iac-ia`.

Caracteristicas principais:

- A IAM Policy contem uma unica statement `Effect: Allow`, restrita exclusivamente as actions e aos recursos informados via variavel (`allowed_actions` e `allowed_resources`).
- E proibida, por validacao em tempo de plan/apply (`lifecycle.precondition`), qualquer combinacao de `Action: "*"` com `Resource: "*"` na mesma statement.
- A IAM Role possui trust policy (assume role policy) restrita a um unico principal configuravel via `trusted_principal_arn`. Nao e permitido `Principal: "*"` nem `"AWS": "*"`.
- A policy criada e anexada diretamente a role via `aws_iam_role_policy_attachment`, nunca ficando sem um principal associado.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este template.
- Nomenclatura segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo `dev-tcc-iam-policy-readonly` e `dev-tcc-iam-role-readonly`.
- Tags obrigatorias (`Project`, `Environment`, `ManagedBy`, `Owner`, `CostCenter`) sao aplicadas a policy e a role.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|:-----------:|-----------------------------------------------------------------------------------------------|
| `environment`             | `string`       | Sim         | Ambiente de implantacao: `dev`, `hml` ou `prd`.                                               |
| `system`                  | `string`       | Sim         | Nome do sistema/aplicacao proprietaria do recurso.                                            |
| `region`                  | `string`       | Nao         | Regiao AWS. Padrao: `us-east-1`.                                                              |
| `additional_tags`         | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                 |
| `policy_name`             | `string`       | Sim         | Finalidade da policy/role, usada como sufixo no padrao de nomenclatura (ex.: `readonly`).     |
| `allowed_actions`         | `list(string)` | Sim         | Lista de IAM Actions permitidas na statement `Allow` da policy.                               |
| `allowed_resources`       | `list(string)` | Sim         | Lista de ARNs de recursos permitidos na statement `Allow` da policy.                          |
| `trusted_principal_arn`   | `string`       | Sim         | ARN unico do principal autorizado a assumir a Role (trust policy). Nao pode ser `"*"`.        |

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

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*"
  ]

  trusted_principal_arn = "arn:aws:iam::111122223333:role/dev-tcc-app-execution"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
