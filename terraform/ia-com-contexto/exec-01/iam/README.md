# IAM Policy anexada a IAM Role

## 1. Visao geral do recurso

Este template provisiona uma IAM Policy gerenciada anexada a uma IAM Role, seguindo o padrao de nomenclatura organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>`.

Caracteristicas de seguranca aplicadas por padrao:

- a trust policy (assume role policy) da role restringe o principal autorizado a assumir a role a um unico ARN, configurado em `trusted_principal_arn`; nao e permitido `Principal: "*"` nem `"AWS": "*"`;
- a policy gerenciada bloqueia, via precondicao de ciclo de vida, qualquer statement que combine `Action: "*"` com `Resource: "*"`;
- a statement `Effect: Allow` da policy e restrita exatamente as actions e resources informados nas variaveis `actions` e `resources`;
- nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada;
- a policy nao fica solta: ela e anexada a role criada via `aws_iam_role_policy_attachment`.

Nomes gerados:

- IAM Policy: `<environment>-<system>-iam-<policy_name>`;
- IAM Role: `<environment>-<system>-iam-<policy_name>-role`.

## 2. Tabela de variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                 | `string`       | Sim         | Nome do sistema ou aplicacao, usado na composicao do nome padronizado.                        |
| `region`                 | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                         |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                  |
| `policy_name`            | `string`       | Sim         | Finalidade da IAM Policy/Role, usada na composicao do nome padronizado (ex.: `readonly`).      |
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico do principal autorizado a assumir a role via trust policy. Proibido valor `"*"`.     |
| `actions`                | `list(string)` | Sim         | Lista de IAM actions permitidas (`Effect: Allow`) na policy.                                   |
| `resources`              | `list(string)` | Sim         | Lista de ARNs de recursos aos quais as actions permitidas se aplicam.                          |

## 3. Tabela de outputs

| Nome          | Descricao                              |
|---------------|------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                |
| `policy_arn`  | ARN da IAM Policy criada.                 |
| `policy_id`   | ID da IAM Policy criada.                  |
| `role_name`   | Nome da IAM Role criada.                  |
| `role_arn`    | ARN da IAM Role criada.                   |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"

  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/dev-tcc-app-execution"

  actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*"
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
