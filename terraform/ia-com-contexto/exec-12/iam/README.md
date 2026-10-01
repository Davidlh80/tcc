# IAM Policy anexada a IAM Role

## Visao geral

Este template cria uma IAM Policy de menor privilegio e uma IAM Role, anexando a policy diretamente a role (nenhuma policy fica solta, sem principal associado). A trust policy (assume role policy) da role e restrita a um unico principal configuravel via variavel, sendo proibido o uso de `Principal: "*"` ou `"AWS": "*"`. A policy nao permite a combinacao de `Action: "*"` com `Resource: "*"` na mesma statement, e o `Effect: Allow` e restrito exclusivamente as acoes e recursos informados por variavel. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada. Os recursos seguem o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` e as tags obrigatorias da organizacao.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                           |
|---------------------------|----------------|:-----------:|-------------------------------------------------------------------------------------------------------|
| `environment`              | `string`        | Sim          | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                       |
| `system`                   | `string`        | Sim          | Nome do sistema/aplicacao, usado na nomenclatura padronizada.                                          |
| `region`                   | `string`        | Nao          | Regiao AWS utilizada para configurar o provider. Padrao: `us-east-1`.                                  |
| `additional_tags`          | `map(string)`   | Nao          | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                       |
| `policy_name`              | `string`        | Sim          | Finalidade/identificador da IAM Policy e da IAM Role, usado na nomenclatura padronizada.                |
| `trusted_principal_arn`    | `string`        | Sim          | ARN unico do principal autorizado a assumir a IAM Role. Nao pode ser `*`.                               |
| `allowed_actions`          | `list(string)`  | Sim          | Lista de acoes IAM permitidas (`Effect Allow`) na policy.                                              |
| `allowed_resources`        | `list(string)`  | Sim          | Lista de ARNs/recursos permitidos (`Effect Allow`) na policy.                                          |

## Outputs

| Nome          | Descricao                                             |
|----------------|--------------------------------------------------------|
| `policy_name`   | Nome da IAM Policy criada.                              |
| `policy_arn`    | ARN da IAM Policy criada.                               |
| `policy_id`     | ID da IAM Policy criada.                                |
| `role_name`     | Nome da IAM Role criada e associada a policy.           |
| `role_arn`      | ARN da IAM Role criada e associada a policy.            |

## Exemplo de uso

```hcl
module "iam_role_attachment" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"

  policy_name = "readonly"

  trusted_principal_arn = "arn:aws:iam::123456789012:role/app-dev-role"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*",
  ]

  additional_tags = {
    Team = "plataforma"
  }
}
```
