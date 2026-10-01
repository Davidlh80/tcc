# IAM Policy anexada a IAM Role

## Visao geral

Este template provisiona uma IAM Policy de minimo privilegio e uma IAM Role que a utiliza, seguindo o padrao organizacional `tcc-iac-ia`:

- Cria uma `aws_iam_policy` cuja unica statement `Allow` e restrita exatamente as actions e aos resources informados pelas variaveis `iam_actions` e `iam_resources`. A combinacao `Action = "*"` com `Resource = "*"` na mesma statement e bloqueada por uma precondicao de `lifecycle`.
- Cria uma `aws_iam_role` cuja trust policy (`assume_role_policy`) autoriza exclusivamente o principal definido em `trusted_principal_arn` (um unico ARN) a executar `sts:AssumeRole`. Nao e permitido `Principal: "*"` nem `"AWS": "*"`.
- Anexa a policy criada a role via `aws_iam_role_policy_attachment`, garantindo que a policy nunca fique sem principal associado.
- Nao anexa nem replica nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`).
- Segue o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `dev-tcc-iam-policy-readonly` e `dev-tcc-iam-role-readonly`) e aplica as tags obrigatorias da organizacao, mescladas com `additional_tags`.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                 | `string`       | Sim         | Nome curto do sistema/aplicacao, usado no padrao de nomenclatura.                              |
| `region`                 | `string`       | Nao         | Regiao AWS do provider. Padrao: `us-east-1`.                                                  |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.                              |
| `policy_name`            | `string`       | Sim         | Finalidade/identificador usado no ultimo segmento do nome da policy e da role.                 |
| `iam_actions`             | `list(string)` | Sim         | Actions permitidas na statement `Allow` da policy.                                             |
| `iam_resources`           | `list(string)` | Sim         | ARNs de recursos permitidos na statement `Allow` da policy.                                    |
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico (conta, usuario ou role) autorizado a assumir a role via `sts:AssumeRole`.           |
| `max_session_duration`   | `number`       | Nao         | Duracao maxima, em segundos, da sessao assumida (3600 a 43200). Padrao: `3600`.                |

## Outputs

| Nome          | Descricao                                |
|---------------|-------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                |
| `policy_arn`  | ARN da IAM Policy criada.                 |
| `policy_id`   | ID da IAM Policy criada.                  |
| `role_name`   | Nome da IAM Role criada.                  |
| `role_arn`    | ARN da IAM Role criada.                   |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"

  policy_name = "readonly"

  iam_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  iam_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*",
  ]

  trusted_principal_arn = "arn:aws:iam::123456789012:role/dev-tcc-app-runner"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
