# IAM Policy - dev-tcc-iam-\<finalidade\>

## Visao geral

Este template provisiona uma IAM Policy da AWS seguindo o padrao organizacional de menor privilegio. A policy contem uma unica statement `Allow`, cujas `actions` e `resources` sao definidas exclusivamente por variavel. E proibida, por validacao em tempo de plano (`lifecycle.precondition`), qualquer combinacao de `Action: "*"` com `Resource: "*"` na mesma statement. Este template nao cria nem replica anexos de policies gerenciadas administrativas (ex.: `AdministratorAccess`) — apenas o recurso `aws_iam_policy` e provisionado.

O nome da policy segue o padrao `<ambiente>-<sistema>-iam-<finalidade>` (ex.: `prd-tcc-iam-readonly`).

## Variaveis

| Nome               | Tipo         | Obrigatoria | Descricao                                                                                          |
|--------------------|--------------|-------------|------------------------------------------------------------------------------------------------------|
| environment        | string       | sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                     |
| system             | string       | sim         | Nome do sistema/aplicacao dono do recurso, usado na nomenclatura padronizada.                        |
| region             | string       | sim         | Regiao AWS onde os recursos serao provisionados.                                                     |
| additional_tags    | map(string)  | nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Default: `{}`.                    |
| policy_name        | string       | sim         | Finalidade da policy, usada na nomenclatura padronizada (`<ambiente>-<sistema>-iam-<finalidade>`).   |
| description        | string       | nao         | Descricao da IAM Policy. Possui valor padrao.                                                        |
| allowed_actions    | list(string) | sim         | Actions IAM permitidas na statement Allow. Nao pode ser `["*"]` combinado com `allowed_resources = ["*"]`. |
| allowed_resources  | list(string) | sim         | ARNs de recursos permitidos na statement Allow. Nao pode ser `["*"]` combinado com `allowed_actions = ["*"]`. |

## Outputs

| Nome         | Descricao                          |
|--------------|-------------------------------------|
| policy_name  | Nome da IAM Policy criada.          |
| policy_arn   | ARN da IAM Policy criada.           |
| policy_id    | ID da IAM Policy criada.            |

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
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::prd-tcc-s3-logs",
    "arn:aws:s3:::prd-tcc-s3-logs/*",
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
