# IAM Policy — dev-tcc-iam-<finalidade>

## 1. Visao geral

Este modulo cria uma IAM Policy da AWS seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao.

A policy gerada:

- possui uma unica statement com `Effect: Allow`, restrita exclusivamente as acoes e recursos informados via variavel (`allowed_actions` e `allowed_resources`);
- bloqueia, atraves de uma precondicao (`lifecycle.precondition`) avaliada em `plan`/`apply`, qualquer combinacao de `Action: "*"` com `Resource: "*"` na mesma statement;
- nao anexa nem replica nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) — este modulo apenas cria a policy, sem realizar attachments a usuarios, grupos ou roles;
- segue o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>`, resultando em nomes como `dev-tcc-iam-readonly` ou `prd-tcc-iam-deploy`;
- aplica o conjunto de tags obrigatorias da organizacao (`Project`, `Environment`, `ManagedBy`, `Owner`, `CostCenter`), mescladas com tags adicionais opcionais.

## 2. Variaveis

| Nome                   | Tipo           | Obrigatoria | Descricao                                                                                  |
|------------------------|----------------|:-----------:|---------------------------------------------------------------------------------------------|
| `environment`          | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                            |
| `system`               | `string`       | Sim         | Identificador do sistema/produto, usado na nomenclatura padronizada.                        |
| `region`               | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                       |
| `additional_tags`      | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.            |
| `policy_name`          | `string`       | Sim         | Finalidade da IAM Policy, usada na composicao do nome padronizado (ex.: `readonly`).        |
| `policy_description`   | `string`       | Nao         | Descricao da IAM Policy. Padrao: `"Managed by Terraform."`.                                 |
| `allowed_actions`      | `list(string)` | Sim         | Lista de acoes IAM permitidas na statement `Allow`.                                          |
| `allowed_resources`    | `list(string)` | Sim         | Lista de ARNs de recursos aos quais as acoes permitidas se aplicam.                          |

## 3. Outputs

| Nome           | Descricao                                  |
|----------------|----------------------------------------------|
| `policy_name`  | Nome padronizado da IAM Policy criada.       |
| `policy_arn`   | ARN da IAM Policy criada.                    |
| `policy_id`    | ID da IAM Policy criada.                     |

## 4. Exemplo de uso

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
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*",
  ]

  additional_tags = {
    Team = "plataforma"
  }
}
```
