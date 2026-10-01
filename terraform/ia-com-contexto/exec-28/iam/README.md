# IAM Policy anexada a IAM Role

## Visao geral

Este template provisiona uma IAM Policy de menor privilegio e uma IAM Role associada, seguindo os padroes internos de nomenclatura, tags e governanca da organizacao.

Caracteristicas principais:

- A IAM Policy nunca fica solta: e sempre anexada a uma IAM Role via `aws_iam_role_policy_attachment`.
- A trust policy (assume role policy) da Role restringe o principal autorizado via `var.trusted_principal_arn`, proibindo `Principal: "*"`.
- A policy proibe, por meio de uma `precondition`, a combinacao de `Action: "*"` com `Resource: "*"` na mesma statement.
- O `Effect: Allow` e restrito exclusivamente as acoes e recursos informados pelas variaveis `allowed_actions` e `allowed_resources`.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- Nomenclatura dos recursos segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`.
- Tags obrigatorias da organizacao sao aplicadas a todos os recursos que suportam tags.

## Variaveis

| Nome                    | Tipo           | Obrigatoria | Descricao                                                                                   |
|-------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`           | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                | `string`       | Sim         | Nome do sistema ou aplicacao associado ao recurso.                                             |
| `region`                | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                          |
| `additional_tags`       | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.                              |
| `policy_name`           | `string`       | Sim         | Finalidade da IAM Policy/Role, usada na composicao do nome padronizado.                        |
| `trusted_principal_arn` | `string`       | Sim         | ARN do principal autorizado a assumir a Role. Nao pode ser `"*"`.                               |
| `allowed_actions`       | `list(string)` | Sim         | Lista de acoes IAM permitidas (`Effect = Allow`).                                              |
| `allowed_resources`     | `list(string)` | Sim         | Lista de ARNs de recursos aos quais as acoes permitidas se aplicam.                            |

## Outputs

| Nome          | Descricao                                             |
|---------------|--------------------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                             |
| `policy_arn`  | ARN da IAM Policy criada.                              |
| `policy_id`   | ID da IAM Policy criada.                               |
| `role_name`   | Nome da IAM Role a qual a policy foi anexada.          |
| `role_arn`    | ARN da IAM Role a qual a policy foi anexada.           |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./caminho/para/este/modulo"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  trusted_principal_arn = "arn:aws:iam::123456789012:role/dev-tcc-app-execution"

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
