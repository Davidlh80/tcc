# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template provisiona uma IAM Policy customizada anexada a uma IAM Role dedicada, seguindo o principio do menor privilegio.

A trust policy (assume role policy) da IAM Role fica restrita a um unico principal informado por variavel, sem uso de wildcard em `Principal`. A IAM Policy contem uma unica statement `Allow`, cujas `Action` e `Resource` sao informadas por variavel, sendo proibida a combinacao `Action: "*"` com `Resource: "*"` na mesma statement. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.

Os recursos seguem o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` e as tags obrigatorias da organizacao.

## 2. Variaveis

| Nome                    | Tipo         | Obrigatoria | Descricao                                                                                   |
|-------------------------|--------------|-------------|-----------------------------------------------------------------------------------------------|
| environment             | string       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| system                  | string       | Sim         | Nome do sistema/aplicacao proprietaria do recurso.                                            |
| region                  | string       | Sim         | Regiao AWS onde o provider ira operar.                                                        |
| additional_tags         | map(string)  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.               |
| policy_name             | string       | Sim         | Finalidade da IAM Policy/Role, usada na nomenclatura padrao.                                   |
| trusted_principal_arn   | string       | Sim         | ARN do principal autorizado a assumir a IAM Role. Nao pode ser `"*"`.                          |
| allowed_actions         | list(string) | Sim         | Acoes IAM permitidas na statement `Allow` da policy.                                          |
| allowed_resources       | list(string) | Sim         | ARNs de recursos permitidos na statement `Allow` da policy.                                   |

## 3. Outputs

| Nome        | Descricao                                                  |
|-------------|--------------------------------------------------------------|
| policy_name | Nome da IAM Policy criada.                                    |
| policy_arn  | ARN da IAM Policy criada.                                     |
| policy_id   | ID da IAM Policy criada.                                       |
| role_name   | Nome da IAM Role criada e associada a IAM Policy.              |
| role_arn    | ARN da IAM Role criada e associada a IAM Policy.               |
| role_id     | Unique ID da IAM Role criada e associada a IAM Policy.         |

## 4. Exemplo de uso

    module "iam_readonly" {
      source = "./"

      environment = "prd"
      system      = "tcc"
      region      = "us-east-1"
      policy_name = "readonly"

      trusted_principal_arn = "arn:aws:iam::123456789012:role/prd-tcc-iam-role-app"

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
