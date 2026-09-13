# IAM Policy

## Visão geral

Este template provisiona uma IAM Policy da AWS seguindo os padrões organizacionais de nomenclatura, tags e segurança. A policy é composta por uma única statement `Allow`, restrita exclusivamente às ações e aos recursos informados via variável, sem qualquer statement que combine `Action: "*"` com `Resource: "*"`, e sem anexação ou replicação de policies gerenciadas administrativas (ex.: `AdministratorAccess`).

O nome do recurso segue o padrão `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo: `dev-tcc-iam-readonly`.

## Variáveis

| Nome                  | Tipo         | Obrigatória | Descrição                                                                                   |
|-----------------------|--------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`         | string       | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                              |
| `system`              | string       | Sim         | Identificador do sistema/aplicação, usado na composição do nome padronizado.                  |
| `region`              | string       | Sim         | Região AWS onde o provider será configurado.                                                  |
| `additional_tags`     | map(string)  | Não         | Tags adicionais mescladas com as tags obrigatórias da organização. Padrão: `{}`.               |
| `policy_name`         | string       | Sim         | Finalidade da policy, usada na composição do nome padronizado (ex.: `readonly`, `deploy`).     |
| `policy_description`  | string       | Não         | Descrição da IAM Policy. Padrão: `"Managed by Terraform."`.                                   |
| `allowed_actions`     | list(string) | Sim         | Ações IAM permitidas na statement `Allow`.                                                     |
| `allowed_resources`   | list(string) | Sim         | Recursos (ARNs) permitidos na statement `Allow`.                                               |

## Outputs

| Nome          | Descrição                                |
|---------------|-------------------------------------------|
| `policy_name` | Nome padronizado da IAM Policy criada.    |
| `policy_arn`  | ARN da IAM Policy criada.                 |
| `policy_id`   | ID da IAM Policy criada.                  |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

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
