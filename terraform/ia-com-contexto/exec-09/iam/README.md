# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template provisiona uma IAM Policy de minimo privilegio anexada a uma IAM Role dedicada, seguindo os padroes organizacionais de nomenclatura, tags e governanca de IAM.

Caracteristicas principais:

- A IAM Policy nunca fica solta: e sempre anexada a uma IAM Role por meio de `aws_iam_role_policy_attachment`.
- A trust policy (assume role policy) da Role restringe o principal autorizado via `var.trusted_principal_arn`, proibindo `Principal: "*"` ou `"AWS": "*"`.
- A statement de permissoes usa `Effect: Allow` restrito exatamente as actions e aos recursos informados pelas variaveis `allowed_actions` e `allowed_resources`.
- Uma precondition de `lifecycle` bloqueia a combinacao de `Action: "*"` com `Resource: "*"` na mesma statement.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- Nome dos recursos segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `dev-tcc-iam-readonly-role`).
- Tags obrigatorias da organizacao sao aplicadas a Role e a Policy, mescladas com `additional_tags`.

## 2. Variaveis

| Nome                      | Tipo           | Obrigatoria | Descricao                                                                                   |
|----------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`               | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                               |
| `system`                    | `string`       | Sim         | Nome do sistema/projeto, usado na composicao do nome padronizado.                              |
| `region`                    | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                          |
| `additional_tags`           | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                |
| `policy_name`               | `string`       | Sim         | Finalidade da IAM Policy/Role, usada na composicao do nome padronizado (ex.: `readonly`).       |
| `allowed_actions`           | `list(string)` | Sim         | Lista de actions IAM permitidas (`Effect: Allow`).                                              |
| `allowed_resources`         | `list(string)` | Sim         | Lista de ARNs/recursos permitidos (`Effect: Allow`).                                            |
| `trusted_principal_arn`     | `string`       | Sim         | ARN (ou principal de servico) autorizado a assumir a Role. Nao pode ser `"*"`.                  |

## 3. Outputs

| Nome          | Descricao                              |
|---------------|-----------------------------------------|
| `policy_name` | Nome da IAM Policy criada.               |
| `policy_arn`  | ARN da IAM Policy criada.                |
| `policy_id`   | ID da IAM Policy criada.                 |
| `role_name`   | Nome da IAM Role criada.                 |
| `role_arn`    | ARN da IAM Role criada.                  |

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
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*"
  ]

  trusted_principal_arn = "arn:aws:iam::123456789012:role/dev-tcc-iam-ci-role"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
