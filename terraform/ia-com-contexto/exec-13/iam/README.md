# IAM Policy anexada a IAM Role

## Visao geral do recurso

Este template provisiona uma IAM Policy de minimo privilegio e uma IAM Role na AWS, com a policy anexada diretamente a role (nenhuma policy fica solta, sem principal associado). A trust policy (assume role policy) da role restringe o assume-role a um unico principal configuravel via `trusted_principal_arn`, sendo proibido o uso de `Principal: "*"` ou `"AWS": "*"`. A policy gerada permite apenas as acoes e recursos informados pelas variaveis `allowed_actions` e `allowed_resources`, e uma precondicao de ciclo de vida impede que uma mesma statement combine `Action: "*"` com `Resource: "*"`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada. Os nomes dos recursos seguem o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` e todos os recursos recebem as tags obrigatorias da organizacao.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                           |
|--------------------------|----------------|-------------|-------------------------------------------------------------------------------------------------------|
| `environment`             | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                     |
| `system`                  | `string`       | Sim         | Nome do sistema/aplicacao proprietaria do recurso, usado no padrao de nomenclatura.                  |
| `region`                  | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                                |
| `additional_tags`         | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                        |
| `policy_name`             | `string`       | Sim         | Finalidade da policy/role, usada como sufixo no padrao de nomenclatura.                              |
| `trusted_principal_arn`   | `string`       | Sim         | ARN unico do principal autorizado a assumir a role (trust policy). Nao aceita `"*"`.                 |
| `allowed_actions`         | `list(string)` | Sim         | Lista de acoes IAM permitidas (`Effect: Allow`) na policy.                                           |
| `allowed_resources`       | `list(string)` | Sim         | Lista de ARNs de recursos aos quais as acoes permitidas se aplicam.                                  |

## Outputs

| Nome          | Descricao                               |
|---------------|-------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                |
| `policy_arn`  | ARN da IAM Policy criada.                 |
| `policy_id`   | ID da IAM Policy criada.                  |
| `role_name`   | Nome da IAM Role criada.                  |
| `role_arn`    | ARN da IAM Role criada.                   |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  trusted_principal_arn = "arn:aws:iam::123456789012:role/dev-tcc-app-role"

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
