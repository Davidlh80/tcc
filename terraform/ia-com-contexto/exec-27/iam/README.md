# IAM Policy

## 1. Visao geral do recurso

Este modulo cria uma IAM Policy AWS seguindo os padroes internos de nomenclatura e governanca da organizacao. A policy gerada contem uma unica statement com `Effect: Allow`, restrita exclusivamente as acoes e recursos informados por variavel, aplicando o principio do menor privilegio.

Regras de seguranca aplicadas automaticamente:

- E proibida a combinacao de `Action: "*"` com `Resource: "*"` na mesma statement (validada via `precondition` no recurso).
- O `Effect: Allow` e restrito apenas as acoes (`allowed_actions`) e recursos (`allowed_resources`) informados por variavel.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este modulo.
- O nome do recurso segue o padrao `<ambiente>-<sistema>-iam-<finalidade>`.

## 2. Variaveis

| Nome                  | Tipo           | Obrigatoria | Descricao                                                                 |
|-----------------------|----------------|-------------|----------------------------------------------------------------------------|
| `environment`         | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml`, `prd`).                              |
| `system`              | `string`       | Sim         | Nome do sistema ou aplicacao ao qual o recurso pertence.                    |
| `region`              | `string`       | Nao         | Regiao AWS onde o provider sera configurado. Padrao: `us-east-1`.          |
| `additional_tags`     | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.           |
| `policy_name`         | `string`       | Sim         | Finalidade da policy, usada na composicao do nome padronizado.              |
| `policy_description`  | `string`       | Nao         | Descricao da IAM Policy. Padrao: `"Managed by Terraform."`.                 |
| `allowed_actions`     | `list(string)` | Sim         | Lista de acoes IAM permitidas na policy.                                    |
| `allowed_resources`   | `list(string)` | Sim         | Lista de ARNs de recursos aos quais as acoes permitidas se aplicam.         |

## 3. Outputs

| Nome           | Descricao                             |
|----------------|-----------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.               |
| `policy_arn`   | ARN da IAM Policy criada.                |
| `policy_id`    | ID da IAM Policy criada.                 |

## 4. Exemplo de uso

```hcl
module "iam_policy_readonly" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

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
