# IAM Policy anexada a IAM Role

## Visao geral

Este template cria uma IAM Policy de menor privilegio e uma IAM Role dedicada, anexando a policy a role por meio de `aws_iam_role_policy_attachment` (a policy nunca permanece solta, sem principal associado). A trust policy (assume role policy) da role e restrita a um unico principal especifico, definido pela variavel `trusted_principal_arn`, sendo proibido o uso de `Principal: "*"` ou `"AWS": "*"`. A statement `Effect: Allow` da policy usa exclusivamente as actions e recursos informados pelas variaveis `allowed_actions` e `allowed_resources`, e um precondition no recurso impede a combinacao proibida `Action: "*"` com `Resource: "*"` na mesma statement. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada. Os nomes dos recursos seguem o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` e todas as tags obrigatorias da organizacao sao aplicadas.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                           |
|---------------------------|----------------|-------------|-------------------------------------------------------------------------------------------------------|
| `environment`             | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                     |
| `system`                  | `string`       | Sim         | Identificador do sistema/aplicacao, usado na nomenclatura padronizada.                                |
| `region`                  | `string`       | Sim         | Regiao AWS onde o provider sera configurado.                                                          |
| `additional_tags`         | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                      |
| `policy_name`             | `string`       | Sim         | Finalidade da IAM Policy/Role, usada no padrao de nomenclatura.                                       |
| `trusted_principal_arn`   | `string`       | Sim         | ARN unico do principal autorizado a assumir a Role (trust policy). Nunca pode ser `"*"`.              |
| `allowed_actions`         | `list(string)` | Sim         | Lista de IAM Actions permitidas na statement Allow.                                                   |
| `allowed_resources`       | `list(string)` | Sim         | Lista de ARNs/recursos permitidos na statement Allow.                                                 |

## Outputs

| Nome          | Descricao                                      |
|----------------|------------------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.                     |
| `policy_arn`   | ARN da IAM Policy criada.                      |
| `policy_id`    | ID da IAM Policy criada.                       |
| `role_name`    | Nome da IAM Role criada e anexada a policy.    |
| `role_arn`     | ARN da IAM Role criada e anexada a policy.     |

## Exemplo de uso

```
module "iam_role_readonly" {
  source = "./"

  environment            = "dev"
  system                 = "tcc"
  region                 = "us-east-1"
  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/app-dev"

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
