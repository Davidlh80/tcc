# IAM Policy

## Visao geral

Este modulo Terraform cria uma IAM Policy customer-managed na AWS, seguindo o padrao de nomenclatura `<ambiente>-<sistema>-iam-<finalidade>` e as tags obrigatorias da organizacao.

A policy gerada contem uma unica statement com `Effect: Allow`, restrita exatamente as acoes e aos recursos informados pelas variaveis `allowed_actions` e `allowed_resources`. E proibido, por validacao em tempo de plano/apply (`lifecycle.precondition`), que a statement combine `Action: "*"` com `Resource: "*"` na mesma regra, evitando a replicacao de privilegios equivalentes a policies administrativas como `AdministratorAccess`. Este modulo nao cria nem anexa nenhuma policy gerenciada pela AWS, apenas a policy customer-managed definida pelo consumidor.

## Variaveis

| Nome                | Tipo         | Obrigatoria | Descricao                                                                                     |
|---------------------|--------------|-------------|-------------------------------------------------------------------------------------------------|
| environment         | string       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                |
| system              | string       | Sim         | Nome do sistema/aplicacao, usado na padronizacao de nomenclatura.                               |
| region              | string       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                           |
| policy_name         | string       | Sim         | Finalidade da IAM Policy, usada na composicao do nome padronizado.                              |
| policy_description  | string       | Nao         | Descricao da IAM Policy. Padrao: `"Policy gerenciada via Terraform."`.                          |
| allowed_actions     | list(string) | Sim         | Lista de acoes IAM permitidas na statement Allow.                                               |
| allowed_resources   | list(string) | Sim         | Lista de ARNs aos quais as acoes permitidas se aplicam.                                         |
| additional_tags     | map(string)  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                 |

## Outputs

| Nome         | Descricao                          |
|--------------|-------------------------------------|
| policy_name  | Nome da IAM Policy criada.          |
| policy_arn   | ARN da IAM Policy criada.           |
| policy_id    | ID da IAM Policy criada.            |

## Exemplo de uso

```hcl
module "iam_policy" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"

  policy_name        = "readonly"
  policy_description = "Acesso somente leitura a objetos de um bucket especifico."

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
