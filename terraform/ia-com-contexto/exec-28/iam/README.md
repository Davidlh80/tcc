# IAM Policy — dev-tcc-iam-<finalidade>

## 1. Visao geral

Este modulo cria uma IAM Policy da AWS seguindo o padrao organizacional de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `dev-tcc-iam-readonly`).

A policy e composta por uma unica statement com `Effect: Allow`, restrita exclusivamente as actions e aos recursos informados via variavel. O modulo aplica as seguintes regras de seguranca:

- proibicao explicita de uma statement que combine `Action: "*"` com `Resource: "*"` (validada via `lifecycle.precondition`);
- nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada;
- actions e recursos permitidos sao totalmente configuraveis por variavel, sem valores fixos no codigo;
- tags obrigatorias da organizacao aplicadas automaticamente, com possibilidade de extensao via `additional_tags`.

## 2. Variaveis

| Nome                  | Tipo           | Obrigatoria | Descricao                                                                                   |
|-----------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`         | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`               | `string`       | Sim         | Nome do sistema ou produto, usado na nomenclatura padronizada.                                |
| `region`               | `string`       | Nao         | Regiao AWS do provider. Padrao: `us-east-1`.                                                  |
| `additional_tags`      | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.               |
| `policy_name`          | `string`       | Sim         | Finalidade da policy, usada na composicao do nome padronizado (ex.: `readonly`, `deploy`).     |
| `policy_description`   | `string`       | Nao         | Descricao da IAM Policy.                                                                       |
| `allowed_actions`      | `list(string)` | Sim         | Actions IAM permitidas na statement Allow.                                                     |
| `allowed_resources`    | `list(string)` | Sim         | ARNs de recursos permitidos na statement Allow.                                                |

## 3. Outputs

| Nome           | Descricao                                  |
|----------------|----------------------------------------------|
| `policy_name`  | Nome completo da IAM Policy criada.          |
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
    Squad = "plataforma"
  }
}
```
