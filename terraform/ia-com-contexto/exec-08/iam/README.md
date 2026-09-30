# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template provisiona uma IAM Policy de minimo privilegio e uma IAM Role dedicada, com a policy anexada diretamente a role (nenhuma policy fica solta, sem principal associado). A trust policy (assume role policy) da role e restrita a um unico principal AWS informado por variavel, sendo proibido o uso de `Principal: "*"` ou `"AWS": "*"`. A statement `Allow` da policy fica restrita exclusivamente as acoes e aos recursos informados via variavel, e uma verificacao (`check`) impede que `Action: "*"` seja combinado com `Resource: "*"` na mesma statement. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada. Os nomes seguem o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` e todos os recursos recebem o conjunto de tags obrigatorias da organizacao.

## 2. Variaveis

| Nome                    | Tipo           | Obrigatoria | Descricao                                                                                   |
|-------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                 | `string`       | Sim         | Nome do sistema ou aplicacao ao qual o recurso pertence.                                      |
| `region`                 | `string`       | Nao         | Regiao AWS utilizada pelo provider. Padrao: `us-east-1`.                                      |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.              |
| `policy_name`            | `string`       | Sim         | Finalidade da policy, usada para compor o nome padronizado (ex.: `readonly`, `deploy`).       |
| `trusted_principal_arn`  | `string`       | Sim         | ARN do principal (usuario, role ou conta) autorizado a assumir a role. Nao pode ser `"*"`.    |
| `allowed_actions`        | `list(string)` | Sim         | Lista de acoes IAM permitidas na statement Allow da policy.                                   |
| `allowed_resources`      | `list(string)` | Sim         | Lista de recursos (ARNs) aos quais as acoes permitidas se aplicam.                            |

## 3. Outputs

| Nome           | Descricao                                              |
|----------------|----------------------------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.                                |
| `policy_arn`   | ARN da IAM Policy criada.                                 |
| `policy_id`    | ID da IAM Policy criada.                                  |
| `role_name`    | Nome da IAM Role criada e associada a policy.             |
| `role_arn`     | ARN da IAM Role criada e associada a policy.              |
| `role_id`      | Identificador unico (unique_id) da IAM Role criada.       |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  trusted_principal_arn = "arn:aws:iam::123456789012:role/plataforma-devops"

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
