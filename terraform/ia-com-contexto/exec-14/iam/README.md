# IAM Policy anexada a IAM Role

## 1. Visao geral do recurso

Este modulo Terraform provisiona uma IAM Policy customizada e uma IAM Role dedicada, anexando a policy a role (nenhum dos dois recursos fica solto ou sem associacao).

Caracteristicas de seguranca aplicadas por padrao:

- a trust policy (assume role policy) da role e restrita a um unico principal configuravel por variavel (`trusted_principal_arn`), sendo proibido o uso de `Principal: "*"` ou `"AWS": "*"`;
- a statement da policy nao pode combinar `Action: "*"` com `Resource: "*"` (validado via `precondition` no recurso `aws_iam_policy`);
- o `Effect: Allow` e restrito exclusivamente as actions e aos recursos informados pelas variaveis `iam_actions` e `iam_resources`;
- nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada;
- nomenclatura e tags seguem o padrao organizacional: `<ambiente>-<sistema>-<recurso>-<finalidade>` e o conjunto de tags obrigatorias (`Project`, `Environment`, `ManagedBy`, `Owner`, `CostCenter`).

## 2. Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`             | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                  | `string`       | Sim         | Nome do sistema/aplicacao proprietaria do recurso.                                            |
| `region`                  | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                         |
| `additional_tags`         | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                 |
| `policy_name`              | `string`       | Sim         | Finalidade/nome descritivo usado na nomenclatura da policy e da role (ex.: `readonly`).        |
| `trusted_principal_arn`   | `string`       | Sim         | ARN do principal autorizado a assumir a role via `sts:AssumeRole`. Nao pode ser `"*"`.         |
| `iam_actions`             | `list(string)` | Sim         | Actions IAM permitidas (`Effect Allow`) na policy. Nao pode ser somente `["*"]`.               |
| `iam_resources`           | `list(string)` | Sim         | Recursos (ARNs) aos quais as actions permitidas se aplicam. Nao pode ser somente `["*"]`.      |
| `max_session_duration`    | `number`       | Nao         | Duracao maxima, em segundos, da sessao assumida. Padrao: `3600` (min. `3600`, max. `43200`).   |

## 3. Outputs

| Nome          | Descricao                                                    |
|---------------|----------------------------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                                     |
| `policy_arn`  | ARN da IAM Policy criada.                                      |
| `policy_id`   | ID da IAM Policy criada.                                       |
| `role_name`   | Nome da IAM Role criada, a qual a policy foi anexada.          |
| `role_arn`    | ARN da IAM Role criada, a qual a policy foi anexada.           |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment           = "dev"
  system                 = "tcc"
  region                 = "us-east-1"
  policy_name             = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/dev-tcc-app-role"

  iam_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  iam_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*",
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
