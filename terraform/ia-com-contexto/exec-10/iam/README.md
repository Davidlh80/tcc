# IAM Policy

## Visao geral

Este template provisiona uma IAM Policy da AWS seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. A policy contem uma unica statement `Allow`, restrita as acoes e aos recursos informados via variavel. E proibido configurar simultaneamente `Action: "*"` e `Resource: "*"` na mesma statement (validado via precondition em tempo de plano). Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este template.

O nome da policy segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo: `dev-tcc-iam-readonly`.

## Variaveis

| Nome                | Tipo           | Obrigatoria | Descricao                                                                                   |
|---------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`        | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`             | `string`       | Sim         | Nome do sistema/aplicacao dono do recurso, usado na composicao do nome padronizado.           |
| `region`             | `string`       | Sim         | Regiao AWS onde os recursos serao provisionados.                                              |
| `additional_tags`    | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias da organizacao. Padrao: `{}`.                   |
| `policy_name`        | `string`       | Sim         | Finalidade da IAM Policy, usada na composicao do nome padronizado (ex.: `readonly`, `deploy`). |
| `policy_description` | `string`       | Nao         | Descricao da IAM Policy. Padrao: `"Managed by Terraform."`.                                    |
| `allowed_actions`    | `list(string)` | Sim         | Lista de acoes IAM permitidas na statement `Allow`.                                           |
| `allowed_resources`  | `list(string)` | Sim         | Lista de ARNs de recursos permitidos na statement `Allow`.                                    |

## Outputs

| Nome          | Descricao                          |
|---------------|-------------------------------------|
| `policy_name` | Nome da IAM Policy criada.          |
| `policy_arn`  | ARN da IAM Policy criada.           |
| `policy_id`   | ID da IAM Policy criada.            |

## Exemplo de uso

```hcl
module "iam_policy_readonly" {
  source = "./"

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

  additional_tags = {
    Squad = "plataforma"
  }
}
```
