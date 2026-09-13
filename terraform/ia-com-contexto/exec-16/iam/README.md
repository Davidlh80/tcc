# IAM Policy

## Visao geral

Este modulo cria uma IAM Policy gerenciada pela AWS seguindo o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `dev-tcc-iam-readonly`).

A policy e composta por uma unica statement `Allow`, restrita as actions e aos resources informados via variavel, aplicando o principio do menor privilegio. A combinacao de `Action: "*"` com `Resource: "*"` na mesma statement e proibida por uma validacao (`precondition`) no recurso. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este modulo.

## Variaveis

| Nome                | Tipo         | Obrigatoria | Descricao                                                                 |
|---------------------|--------------|-------------|----------------------------------------------------------------------------|
| environment          | string       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                          |
| system               | string       | Nao         | Nome do sistema ou projeto. Padrao: `tcc`.                                |
| region               | string       | Nao         | Regiao AWS de provisionamento. Padrao: `us-east-1`.                       |
| additional_tags      | map(string)  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.             |
| policy_name          | string       | Sim         | Finalidade da policy, usada para compor o nome padronizado.               |
| policy_description   | string       | Nao         | Descricao da IAM Policy.                                                   |
| allowed_actions      | list(string) | Sim         | Actions IAM permitidas na statement Allow.                                |
| allowed_resources    | list(string) | Sim         | ARNs de recursos permitidos na statement Allow.                           |

## Outputs

| Nome         | Descricao                          |
|--------------|--------------------------------------|
| policy_name  | Nome da IAM Policy criada.          |
| policy_arn   | ARN da IAM Policy criada.           |
| policy_id    | ID da IAM Policy criada.            |

## Exemplo de uso

```hcl
module "iam_policy_readonly" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"

  policy_name        = "readonly"
  policy_description = "Permite leitura de objetos em um bucket especifico."

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*"
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
