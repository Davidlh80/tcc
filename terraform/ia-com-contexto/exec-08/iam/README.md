# IAM Policy

## 1. Visao geral do recurso

Este modulo cria uma IAM Policy da AWS seguindo os padroes organizacionais de nomenclatura, tags e seguranca.

O nome do recurso e composto automaticamente no formato `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo `prd-tcc-iam-readonly`.

A policy gerada contem exatamente uma statement com `Effect: Allow`, restrita as acoes e recursos informados via variavel. E proibido, por validacao explicita:

- combinar `Action: "*"` com `Resource: "*"` na mesma statement;
- utilizar `"*"` isoladamente em `allowed_actions` ou `allowed_resources`.

Este modulo nao anexa a policy a nenhuma role, usuario ou grupo, e nao referencia ou replica policies gerenciadas administrativas (ex.: `AdministratorAccess`).

## 2. Variaveis

| Nome                 | Tipo         | Obrigatoria | Descricao                                                                          |
|----------------------|--------------|-------------|-------------------------------------------------------------------------------------|
| `environment`        | string       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                     |
| `system`              | string       | Sim         | Nome do sistema ou projeto ao qual o recurso pertence.                              |
| `region`              | string       | Nao         | Regiao da AWS onde o recurso sera provisionado. Padrao: `us-east-1`.                |
| `additional_tags`     | map(string)  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.     |
| `policy_name`         | string       | Sim         | Finalidade da policy, usada na composicao do nome padronizado (ex.: `readonly`).     |
| `policy_description`  | string       | Nao         | Descricao da IAM Policy.                                                            |
| `allowed_actions`     | list(string) | Sim         | Lista de acoes IAM permitidas na statement Allow.                                   |
| `allowed_resources`   | list(string) | Sim         | Lista de ARNs de recursos aos quais as acoes permitidas se aplicam.                  |

## 3. Outputs

| Nome           | Descricao                          |
|----------------|-------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.          |
| `policy_arn`   | ARN da IAM Policy criada.           |
| `policy_id`    | ID da IAM Policy criada.            |

## 4. Exemplo de uso

```hcl
module "iam_policy_readonly" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name        = "readonly"
  policy_description = "Acesso somente leitura ao bucket de logs do sistema tcc."

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
