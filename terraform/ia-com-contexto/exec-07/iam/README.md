# IAM Policy

## Visao geral

Este template cria uma IAM Policy AWS com uma unica statement de efeito `Allow`, restrita exclusivamente as actions e recursos informados via variavel. A statement e explicitamente impedida de combinar `Action: "*"` com `Resource: "*"` atraves de uma precondicao de validacao. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este template. O nome do recurso segue o padrao organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>` e as tags obrigatorias da organizacao sao aplicadas automaticamente.

## Variaveis

| Nome                | Tipo         | Obrigatoria | Descricao                                                                 |
|---------------------|--------------|-------------|----------------------------------------------------------------------------|
| environment          | string       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                          |
| system               | string       | Sim         | Identificador do sistema/projeto ao qual o recurso pertence.              |
| region               | string       | Sim         | Regiao AWS utilizada para configurar o provider.                          |
| additional_tags      | map(string)  | Nao         | Tags adicionais mescladas as tags obrigatorias da organizacao.            |
| policy_name          | string       | Sim         | Finalidade da policy, usada para compor o nome padronizado do recurso.    |
| policy_description   | string       | Nao         | Descricao da IAM Policy.                                                  |
| allowed_actions      | list(string) | Sim         | Lista de actions IAM permitidas na statement Allow.                       |
| allowed_resources    | list(string) | Sim         | Lista de ARNs/recursos permitidos na statement Allow.                     |

## Outputs

| Nome         | Descricao                          |
|--------------|-------------------------------------|
| policy_name  | Nome da IAM Policy criada.          |
| policy_arn   | ARN da IAM Policy criada.           |
| policy_id    | ID da IAM Policy criada.            |

## Exemplo de uso

```hcl
module "iam_readonly" {
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
