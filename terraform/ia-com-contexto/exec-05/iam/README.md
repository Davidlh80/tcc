# IAM Policy

## Visao geral

Este template provisiona uma IAM Policy gerenciada pela AWS seguindo os padroes de nomenclatura, tags e seguranca definidos pela organizacao. O nome do recurso e composto automaticamente no formato `<ambiente>-<sistema>-iam-<finalidade>` (por exemplo, `prd-tcc-iam-readonly`).

A policy contem uma unica statement com `Effect: Allow`, restrita exclusivamente as acoes e aos recursos informados via variavel. E aplicada uma validacao (`precondition`) que impede a combinacao de `Action: "*"` com `Resource: "*"` na mesma statement, e nenhuma policy gerenciada administrativa (como `AdministratorAccess`) e anexada ou replicada por este template.

## Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|------|------|-------------|-----------|
| `environment` | `string` | Sim | Ambiente de implantacao do recurso (`dev`, `hml` ou `prd`). |
| `system` | `string` | Sim | Nome do sistema ou aplicacao dono do recurso. |
| `region` | `string` | Nao | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`. |
| `additional_tags` | `map(string)` | Nao | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`. |
| `policy_name` | `string` | Sim | Finalidade da IAM Policy, usada como sufixo do nome (`<ambiente>-<sistema>-iam-<finalidade>`). |
| `policy_description` | `string` | Nao | Descricao da IAM Policy. Padrao: `"Policy gerenciada via Terraform."`. |
| `allowed_actions` | `list(string)` | Sim | Lista de acoes IAM permitidas na policy. |
| `allowed_resources` | `list(string)` | Sim | Lista de ARNs de recursos permitidos na policy. |

## Outputs

| Nome | Descricao |
|------|-----------|
| `policy_name` | Nome da IAM Policy criada. |
| `policy_arn` | ARN da IAM Policy criada. |
| `policy_id` | ID da IAM Policy criada. |

## Exemplo de uso

```hcl
module "iam_policy_readonly" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

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
