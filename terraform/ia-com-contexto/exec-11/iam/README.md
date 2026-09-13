# IAM Policy

## Visao geral

Este template provisiona uma IAM Policy gerenciada pelo cliente (customer-managed policy) na AWS, seguindo o padrao de nomenclatura `<ambiente>-<sistema>-iam-<finalidade>`.

A policy e composta por uma unica statement com `Effect = "Allow"`, restrita exclusivamente as acoes e aos recursos informados nas variaveis `allowed_actions` e `allowed_resources`. E proibida, por validacao (`precondition`), a combinacao de `Action = "*"` com `Resource = "*"` na mesma statement. Este template nao anexa nem replica nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) a nenhum principal.

## Variaveis

| Nome              | Tipo         | Obrigatoria | Descricao                                                                                   |
|-------------------|--------------|-------------|-----------------------------------------------------------------------------------------------|
| environment       | string       | Sim         | Ambiente de implantacao do recurso (dev, hml ou prd).                                        |
| system            | string       | Sim         | Nome do sistema ou aplicacao associado ao recurso.                                            |
| region            | string       | Nao         | Regiao AWS onde o provider sera configurado. Padrao: `us-east-1`.                             |
| additional_tags   | map(string)  | Nao         | Tags adicionais a serem mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.      |
| policy_name       | string       | Sim         | Finalidade da IAM Policy, usada para compor o nome completo (ex.: readonly, deploy).           |
| description       | string       | Nao         | Descricao da IAM Policy. Padrao: `"Managed by Terraform."`.                                   |
| allowed_actions   | list(string) | Sim         | Lista de acoes IAM permitidas pela policy.                                                    |
| allowed_resources | list(string) | Sim         | Lista de ARNs de recursos aos quais as acoes permitidas se aplicam.                            |

## Outputs

| Nome        | Descricao                              |
|-------------|-----------------------------------------|
| policy_name | Nome da IAM Policy criada.              |
| policy_arn  | ARN da IAM Policy criada.               |
| policy_id   | ID da IAM Policy criada.                |

## Exemplo de uso

```hcl
module "iam_policy_readonly" {
  source = "./iam-policy"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"
  description = "Acesso somente leitura a bucket especifico de logs."

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
