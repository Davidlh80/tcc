# IAM Policy anexada a IAM Role

## Visao geral

Este template Terraform provisiona uma IAM Policy de menor privilegio e uma IAM Role dedicada, anexando a policy a role (nenhum recurso fica solto, sem principal associado). A trust policy (assume role policy) da role e restrita a um unico principal configuravel por variavel, sem uso de `Principal: "*"` ou `"AWS": "*"`. A policy permite apenas as acoes e recursos informados via variavel, proibindo qualquer statement que combine `Action: "*"` com `Resource: "*"`, e nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada. Todos os recursos seguem o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` e as tags obrigatorias da organizacao.

## Variaveis

| Nome                          | Tipo           | Obrigatoria | Descricao                                                                                   |
|-------------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`                 | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                      | `string`       | Sim         | Nome do sistema/projeto, usado no padrao de nomenclatura.                                     |
| `region`                      | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                          |
| `additional_tags`             | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                |
| `policy_name`                 | `string`       | Sim         | Nome completo da IAM Policy (`<ambiente>-<sistema>-iam-<finalidade>`).                         |
| `role_name`                   | `string`       | Sim         | Nome completo da IAM Role (`<ambiente>-<sistema>-iam-role-<finalidade>`).                      |
| `assume_role_principal_arn`   | `string`       | Sim         | ARN do principal ou service principal autorizado a assumir a role. Nao aceita `"*"`.           |
| `allowed_actions`             | `list(string)` | Sim         | Lista de acoes IAM permitidas na policy. Nao aceita `"*"`.                                      |
| `allowed_resources`           | `list(string)` | Sim         | Lista de recursos (ARNs) permitidos na policy. Nao aceita `"*"`.                                |

## Outputs

| Nome          | Descricao                          |
|---------------|-------------------------------------|
| `policy_name` | Nome da IAM Policy criada.          |
| `policy_arn`  | ARN da IAM Policy criada.           |
| `policy_id`   | ID da IAM Policy criada.            |
| `role_name`   | Nome da IAM Role criada.            |
| `role_arn`    | ARN da IAM Role criada.             |
| `role_id`     | ID da IAM Role criada.              |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./iam"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name = "prd-tcc-iam-readonly"
  role_name   = "prd-tcc-iam-role-readonly"

  assume_role_principal_arn = "arn:aws:iam::123456789012:role/app-server"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::prd-tcc-s3-logs",
    "arn:aws:s3:::prd-tcc-s3-logs/*",
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
