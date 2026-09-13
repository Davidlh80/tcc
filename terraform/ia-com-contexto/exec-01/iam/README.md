# IAM Policy — dev-tcc-iam-\<finalidade\>

## 1. Visao geral

Este modulo provisiona uma IAM Policy gerenciada pela AWS seguindo o padrao de nomenclatura `<ambiente>-<sistema>-iam-<finalidade>` da organizacao.

A policy e composta por uma unica statement `Allow`, cujas acoes e recursos sao definidos exclusivamente por variaveis, aplicando o principio do menor privilegio. O modulo bloqueia, via `precondition` no ciclo de vida do recurso, qualquer combinacao de `Action: "*"` com `Resource: "*"` na mesma statement. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este modulo, pois ele apenas cria a IAM Policy, sem realizar attachments.

## 2. Variaveis

| Nome                 | Tipo         | Obrigatoria | Descricao                                                                                   |
|----------------------|--------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`         | `string`     | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                             |
| `system`               | `string`     | Sim         | Nome do sistema/aplicacao dono do recurso.                                                   |
| `region`               | `string`     | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                        |
| `additional_tags`      | `map(string)`| Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.             |
| `policy_name`          | `string`     | Sim         | Finalidade da policy, usada como ultimo segmento da nomenclatura padronizada.                |
| `policy_description`   | `string`     | Nao         | Descricao da IAM Policy.                                                                      |
| `allowed_actions`      | `list(string)`| Sim        | Lista de acoes IAM permitidas na statement Allow.                                            |
| `allowed_resources`    | `list(string)`| Sim        | Lista de ARNs de recursos aos quais as acoes permitidas se aplicam.                          |

## 3. Outputs

| Nome          | Descricao                          |
|---------------|-------------------------------------|
| `policy_name` | Nome da IAM Policy criada.          |
| `policy_arn`  | ARN da IAM Policy criada.           |
| `policy_id`   | ID da IAM Policy criada.            |

## 4. Exemplo de uso

```hcl
module "iam_policy_readonly" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  policy_description = "Acesso somente leitura ao bucket de logs da aplicacao."

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
