# IAM Policy

## 1. Visao geral

Este modulo cria uma IAM Policy gerenciada pela AWS seguindo os padroes de nomenclatura, tags e seguranca definidos pela organizacao. A policy contem uma unica statement com `Effect: Allow`, restrita as acoes e aos recursos informados por variavel. E proibida qualquer statement que combine `Action: "*"` com `Resource: "*"` na mesma statement, e o modulo nao anexa nem replica policies gerenciadas administrativas (ex.: AdministratorAccess).

O nome do recurso segue o padrao `<ambiente>-<sistema>-iam-<finalidade>`, por exemplo `dev-tcc-iam-readonly`.

## 2. Variaveis

| Nome                 | Tipo           | Obrigatoria | Descricao                                                                            |
|----------------------|----------------|-------------|---------------------------------------------------------------------------------------|
| environment           | string         | Sim         | Ambiente de implantacao (dev, hml ou prd).                                            |
| system                | string         | Sim         | Nome do sistema ou produto ao qual o recurso pertence.                                 |
| region                | string         | Nao         | Regiao AWS onde o provider sera configurado. Padrao: us-east-1.                        |
| additional_tags       | map(string)    | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: {}.          |
| policy_name           | string         | Sim         | Finalidade da IAM Policy, usada no padrao de nomenclatura.                             |
| policy_description    | string         | Nao         | Descricao opcional da IAM Policy. Padrao: descricao gerada automaticamente.            |
| allowed_actions       | list(string)   | Sim         | Lista de acoes IAM permitidas na statement Allow.                                      |
| allowed_resources     | list(string)   | Sim         | Lista de ARNs de recursos permitidos na statement Allow.                               |

## 3. Outputs

| Nome         | Descricao                              |
|--------------|------------------------------------------|
| policy_name  | Nome da IAM Policy criada.                |
| policy_arn   | ARN da IAM Policy criada.                 |
| policy_id    | ID da IAM Policy criada.                  |

## 4. Exemplo de uso

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
