# IAM Policy

## 1. Visao geral do recurso

Este template cria uma IAM Policy gerenciada pelo cliente (customer managed policy), seguindo o principio do menor privilegio.

A policy gerada contem uma unica statement com `Effect: Allow`, restrita as actions e recursos informados via variavel. A combinacao de `Action: "*"` com `Resource: "*"` na mesma statement e proibida e validada em tempo de plano via `lifecycle.precondition`. Este template nao anexa nem replica policies gerenciadas administrativas (ex.: `AdministratorAccess`) a nenhum principal.

O nome do recurso segue o padrao organizacional `<ambiente>-<sistema>-iam-<finalidade>` e todas as tags obrigatorias da organizacao sao aplicadas automaticamente, podendo ser complementadas por `additional_tags`.

## 2. Variaveis

| Nome              | Tipo         | Obrigatoria | Descricao                                                                          |
|-------------------|--------------|-------------|-------------------------------------------------------------------------------------|
| environment       | string       | Sim         | Ambiente de implantacao (dev, hml ou prd).                                          |
| system             | string       | Sim         | Identificador do sistema/aplicacao dono do recurso.                                  |
| region            | string       | Nao         | Regiao AWS usada para configurar o provider. Padrao: us-east-1.                     |
| additional_tags   | map(string)  | Nao         | Tags adicionais mescladas as tags obrigatorias da organizacao. Padrao: {}.           |
| policy_name       | string       | Sim         | Finalidade da policy, usada na nomenclatura <ambiente>-<sistema>-iam-<finalidade>.   |
| allowed_actions   | list(string) | Sim         | Lista de IAM Actions permitidas na policy.                                          |
| allowed_resources | list(string) | Sim         | Lista de ARNs de recursos aos quais as actions serao permitidas.                    |

## 3. Outputs

| Nome        | Descricao                          |
|-------------|-------------------------------------|
| policy_name | Nome da IAM Policy criada.          |
| policy_arn  | ARN da IAM Policy criada.           |
| policy_id   | ID da IAM Policy criada.            |

## 4. Exemplo de uso

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
