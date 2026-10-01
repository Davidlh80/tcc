# IAM Policy anexada a IAM Role

## 1. Visao geral

Este modulo provisiona uma IAM Policy de minimo privilegio e uma IAM Role dedicada, com a policy anexada a role via `aws_iam_role_policy_attachment` (a policy nunca fica solta, sem principal associado).

Caracteristicas de seguranca aplicadas:

- A trust policy (assume role policy) da role restringe o principal autorizado a assumir a role a um unico ARN configuravel por variavel (`trusted_principal_arn`); `Principal: "*"` ou `"AWS": "*"` nao sao permitidos.
- A statement `Effect: Allow` da policy e restrita exatamente as actions e aos recursos informados pelas variaveis `allowed_actions` e `allowed_resources`.
- E proibida, por meio de uma precondition de lifecycle no data source da policy, qualquer combinacao de `Action: "*"` com `Resource: "*"` na mesma statement.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- Nomenclatura de recursos segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` e todos os recursos que suportam tags recebem o conjunto de tags obrigatorias da organizacao, mescladas com `additional_tags`.

## 2. Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                     |
|--------------------------|----------------|:-----------:|------------------------------------------------------------------------------------------------|
| `environment`             | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                  | `string`       | Sim         | Nome curto do sistema/aplicacao, usado na nomenclatura padrao.                                |
| `region`                  | `string`       | Sim         | Regiao AWS onde os recursos serao criados.                                                    |
| `purpose`                 | `string`       | Sim         | Finalidade da policy/role, usada na nomenclatura padrao (ex.: `readonly`, `deploy`).           |
| `trusted_principal_arn`   | `string`       | Sim         | ARN do principal autorizado a assumir a role. Nao pode ser `"*"`.                              |
| `allowed_actions`         | `list(string)` | Sim         | Lista de actions IAM permitidas na statement `Allow` da policy.                               |
| `allowed_resources`       | `list(string)` | Sim         | Lista de ARNs de recursos permitidos na statement `Allow` da policy.                           |
| `additional_tags`         | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.               |

## 3. Outputs

| Nome           | Descricao                                          |
|----------------|-----------------------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.                          |
| `policy_arn`   | ARN da IAM Policy criada.                           |
| `policy_id`    | ID da IAM Policy criada.                            |
| `role_name`    | Nome da IAM Role criada, com a policy anexada.      |
| `role_arn`     | ARN da IAM Role criada.                             |
| `role_id`      | ID da IAM Role criada.                              |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./terraform/iam"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "readonly"

  trusted_principal_arn = "arn:aws:iam::123456789012:role/dev-tcc-app-runtime"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*",
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
