# IAM Policy

## Visao geral

Este template cria uma IAM Policy customizada seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. A policy contem uma unica statement `Allow`, restrita as actions e recursos informados via variavel. Nao e permitida a combinacao `Action: "*"` com `Resource: "*"` na mesma statement (validada por precondition no `main.tf`), e este template nao anexa nem replica policies gerenciadas administrativas (ex.: `AdministratorAccess`).

Nome do recurso segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo: `dev-tcc-iam-readonly`.

## Variaveis

| Nome                 | Tipo           | Obrigatoria | Descricao                                                                                     |
|----------------------|----------------|-------------|------------------------------------------------------------------------------------------------|
| environment          | string         | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                |
| system               | string         | Sim         | Nome curto do sistema ou produto associado ao recurso.                                          |
| region               | string         | Sim         | Regiao AWS onde o recurso sera criado.                                                          |
| additional_tags      | map(string)    | Nao         | Tags adicionais mescladas com as tags obrigatorias.                                              |
| policy_name          | string         | Sim         | Finalidade da policy, usada como sufixo no padrao de nomenclatura.                               |
| policy_description   | string         | Nao         | Descricao da IAM Policy.                                                                         |
| allowed_actions      | list(string)   | Sim         | Lista de actions IAM permitidas na statement Allow.                                              |
| allowed_resources    | list(string)   | Sim         | Lista de ARNs permitidos na statement Allow.                                                     |

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

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  policy_name       = "readonly"
  policy_description = "Acesso somente leitura ao bucket de logs"

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
