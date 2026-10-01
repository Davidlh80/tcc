# IAM Policy anexada a IAM Role

## 1. Visão geral

Este template provisiona uma IAM Policy customizada e uma IAM Role, com a policy anexada à role por meio de `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela é sempre associada a um principal (a Role criada neste mesmo template).

Principais características de segurança:

- A trust policy (assume role policy) da Role é restrita a um único principal informado via variável (`trusted_principal_arn`). Não é permitido `Principal: "*"` nem `"AWS": "*"`.
- A statement `Allow` da policy é restrita exatamente às ações (`allowed_actions`) e recursos (`allowed_resources`) informados por variável.
- É proibida qualquer statement que combine `Action: "*"` com `Resource: "*"`; as variáveis `allowed_actions` e `allowed_resources` não aceitam o valor `"*"` isoladamente, o que impede essa combinação.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) é anexada ou replicada.
- Nomenclatura dos recursos segue o padrão `<ambiente>-<sistema>-iam-<finalidade>`, com sufixos `-role` e `-policy` para diferenciar os dois recursos.
- Tags obrigatórias (`Project`, `Environment`, `ManagedBy`, `Owner`, `CostCenter`) são aplicadas em todos os recursos que suportam tags.

## 2. Variáveis

| Nome                     | Tipo           | Obrigatória | Descrição                                                                                           |
|--------------------------|----------------|-------------|-------------------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                                      |
| `system`                 | `string`       | Não         | Nome do sistema/aplicação. Padrão: `tcc`.                                                             |
| `region`                 | `string`       | Não         | Região AWS onde os recursos serão provisionados. Padrão: `us-east-1`.                                 |
| `additional_tags`        | `map(string)`  | Não         | Tags adicionais mescladas com as tags obrigatórias (não sobrescrevem as obrigatórias). Padrão: `{}`.  |
| `policy_name`            | `string`       | Sim         | Finalidade usada para compor o nome da policy/role no padrão `<ambiente>-<sistema>-iam-<finalidade>`. |
| `policy_description`     | `string`       | Não         | Descrição da IAM Policy.                                                                               |
| `trusted_principal_arn`  | `string`       | Sim         | ARN único do principal autorizado a assumir a Role. Não aceita `"*"`.                                  |
| `allowed_actions`        | `list(string)` | Sim         | Ações IAM permitidas na policy. Não aceita `"*"`.                                                      |
| `allowed_resources`      | `list(string)` | Sim         | ARNs de recursos permitidos na policy. Não aceita `"*"`.                                               |
| `max_session_duration`   | `number`       | Não         | Duração máxima (segundos) da sessão assumida da Role. Padrão: `3600`.                                  |

## 3. Outputs

| Nome          | Descrição                              |
|---------------|------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                |
| `policy_arn`  | ARN da IAM Policy criada.                 |
| `policy_id`   | ID da IAM Policy criada.                  |
| `role_name`   | Nome da IAM Role criada.                  |
| `role_arn`    | ARN da IAM Role criada.                   |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./iam-policy-role"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name            = "readonly"
  policy_description     = "Acesso somente leitura a objetos de um bucket especifico."
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/tcc-ci-deployer"

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
