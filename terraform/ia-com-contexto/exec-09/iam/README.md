# IAM Policy

## 1. Visao geral

Este template cria uma IAM Policy da AWS seguindo os padroes organizacionais de nomenclatura, tags e seguranca.

A policy gerada contem uma unica statement com `Effect: Allow`, restrita exclusivamente as actions e aos recursos informados pelas variaveis `allowed_actions` e `allowed_resources`. Nao e permitido, em nenhuma hipotese, o uso de `Action: "*"` combinado com `Resource: "*"` na mesma statement — essa combinacao e bloqueada por validacao de variaveis, que impede o uso isolado de `"*"` tanto em `allowed_actions` quanto em `allowed_resources`.

O template nao anexa nem replica policies gerenciadas administrativas (ex.: `AdministratorAccess`); ele apenas cria o recurso `aws_iam_policy`, sem qualquer attachment a usuarios, grupos ou roles.

O nome do recurso segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo: `prd-tcc-iam-readonly`.

## 2. Variaveis

| Nome                 | Tipo         | Obrigatoria | Descricao                                                                                     |
|----------------------|--------------|-------------|------------------------------------------------------------------------------------------------|
| environment          | string       | Sim         | Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd.                         |
| system               | string       | Sim         | Nome do sistema ou aplicacao ao qual o recurso pertence.                                       |
| region               | string       | Nao         | Regiao AWS onde o provider sera configurado. Padrao: us-east-1.                                |
| additional_tags      | map(string)  | Nao         | Tags adicionais a serem mescladas as tags obrigatorias. Padrao: {}.                             |
| policy_name          | string       | Sim         | Finalidade da IAM Policy, usada para compor o nome do recurso (ex.: readonly, deploy).          |
| policy_description   | string       | Nao         | Descricao associada a IAM Policy. Padrao: "Managed by Terraform.".                              |
| allowed_actions      | list(string) | Sim         | Lista de actions IAM permitidas. Nao pode conter o valor "*" isolado.                          |
| allowed_resources    | list(string) | Sim         | Lista de ARNs de recursos permitidos. Nao pode conter o valor "*" isolado.                      |

## 3. Outputs

| Nome         | Descricao                          |
|--------------|-------------------------------------|
| policy_name  | Nome da IAM Policy criada.          |
| policy_arn   | ARN da IAM Policy criada.           |
| policy_id    | ID da IAM Policy criada.            |

## 4. Exemplo de uso

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
