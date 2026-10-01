# IAM Policy anexada a IAM Role

## 1. Visão geral

Este módulo provisiona uma IAM Policy customizada e uma IAM Role, anexando a policy à role via `aws_iam_role_policy_attachment`. A trust policy (assume role policy) da role é restrita a principals AWS específicos, informados por variável — não é permitido `Principal: "*"`. A policy segue o princípio do menor privilégio: a statement `Effect: Allow` é restrita exatamente às ações e recursos informados por variável, e a combinação `Action: "*"` com `Resource: "*"` é bloqueada por validação. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) é anexada ou replicada.

Nomenclatura dos recursos segue o padrão `<ambiente>-<sistema>-<recurso>-<finalidade>`:

- Policy: `<environment>-<system>-iam-policy-<policy_name>`
- Role: `<environment>-<system>-iam-role-<policy_name>`

## 2. Variáveis

| Nome                     | Tipo           | Obrigatória | Descrição                                                                                          |
|--------------------------|----------------|-------------|------------------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                                     |
| `system`                 | `string`       | Sim         | Nome do sistema ou aplicação ao qual o recurso pertence.                                             |
| `region`                 | `string`       | Não         | Região AWS onde os recursos serão criados. Padrão: `us-east-1`.                                      |
| `additional_tags`        | `map(string)`  | Não         | Tags adicionais mescladas às tags obrigatórias da organização. Padrão: `{}`.                         |
| `policy_name`             | `string`       | Sim         | Finalidade/identificador da policy e da role, usado na composição do nome padronizado.               |
| `trusted_principal_arns` | `list(string)` | Sim         | ARNs de principals AWS autorizados a assumir a role (trust policy). Não aceita `"*"`.                |
| `allowed_actions`        | `list(string)` | Sim         | Ações IAM permitidas (`Effect: Allow`) na policy.                                                    |
| `allowed_resources`      | `list(string)` | Sim         | ARNs de recursos permitidos (`Effect: Allow`) na policy. Proíbe combinação `"*"` com `allowed_actions` `"*"`. |

## 3. Outputs

| Nome          | Descrição                              |
|---------------|-----------------------------------------|
| `policy_name` | Nome da IAM Policy criada.              |
| `policy_arn`  | ARN da IAM Policy criada.               |
| `policy_id`   | ID da IAM Policy criada.                |
| `role_name`   | Nome da IAM Role criada.                |
| `role_arn`    | ARN da IAM Role criada.                 |
| `role_id`     | ID (unique id) da IAM Role criada.      |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/dev-tcc-app-execution"
  ]

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
