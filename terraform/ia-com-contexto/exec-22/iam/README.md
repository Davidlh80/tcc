# IAM Policy anexada a IAM Role

## 1. Visao geral do recurso

Este template provisiona uma IAM Policy com privilegio minimo e uma IAM Role a qual essa policy e anexada, atendendo aos padroes organizacionais de nomenclatura, tags e seguranca definidos no contexto da organizacao.

Caracteristicas principais:

- A IAM Policy nunca fica solta: ela e sempre anexada a uma IAM Role por meio de `aws_iam_role_policy_attachment`.
- A trust policy (assume role policy) da Role restringe o principal autorizado a assumir a role a um unico ARN, configurado pela variavel `trusted_principal_arn`. Nao e permitido `Principal: "*"` ou `"AWS": "*"`.
- A statement `Effect: Allow` da policy e restrita exatamente as actions e aos resources informados pelas variaveis `allowed_actions` e `allowed_resources`.
- E proibida, por meio de uma validacao (`precondition`), qualquer combinacao de `Action: "*"` com `Resource: "*"` na mesma statement.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- Nomenclatura dos recursos segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`.
- Todas as tags obrigatorias da organizacao sao aplicadas, com possibilidade de tags adicionais via `additional_tags`.

## 2. Tabela de variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                           |
|--------------------------|----------------|-------------|-------------------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                      |
| `system`                 | `string`       | Sim         | Identificador do sistema/aplicacao proprietaria do recurso.                                           |
| `region`                 | `string`       | Sim         | Regiao AWS onde os recursos serao provisionados.                                                      |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Default: `{}`.                     |
| `policy_name`            | `string`       | Sim         | Finalidade da IAM Policy/Role, usada como sufixo na nomenclatura padronizada (ex.: `readonly`).       |
| `allowed_actions`        | `list(string)` | Sim         | Lista de actions IAM permitidas na statement `Allow` da policy.                                       |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs de recursos permitidos na statement `Allow` da policy.                                  |
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico do principal autorizado a assumir a IAM Role na trust policy. Nao pode ser `"*"`.          |

## 3. Tabela de outputs

| Nome          | Descricao                                 |
|---------------|--------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                 |
| `policy_arn`  | ARN da IAM Policy criada.                  |
| `policy_id`   | ID da IAM Policy criada.                   |
| `role_name`   | Nome da IAM Role criada.                   |
| `role_arn`    | ARN da IAM Role criada.                    |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./caminho/para/este/template"

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

  trusted_principal_arn = "arn:aws:iam::123456789012:role/prd-tcc-ec2-app"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
