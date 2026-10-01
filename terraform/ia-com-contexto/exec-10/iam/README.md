# IAM Policy anexada a IAM Role

## Visao geral

Este template provisiona uma IAM Role com uma trust policy restrita a um unico principal configuravel (`trusted_principal_arn`), e uma IAM Policy de minimo privilegio anexada a essa Role via `aws_iam_role_policy_attachment`. A policy nunca fica solta, sem principal associado.

Restricoes de seguranca aplicadas:

- a trust policy nao permite `Principal: "*"` nem `"AWS": "*"`, apenas o ARN informado em `trusted_principal_arn`;
- e proibida qualquer statement que combine `Action: "*"` com `Resource: "*"` (validado via `precondition`);
- o `Effect: Allow` da policy e restrito exclusivamente as actions e recursos informados pelas variaveis `allowed_actions` e `allowed_resources`;
- nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este template.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                 | `string`       | Sim         | Nome do sistema ou aplicacao proprietaria do recurso.                                         |
| `region`                 | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                         |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                  |
| `policy_name`            | `string`       | Sim         | Finalidade da IAM Policy/Role, usada na composicao do nome padronizado.                       |
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico do principal autorizado a assumir a Role. Nao aceita wildcard.                       |
| `allowed_actions`        | `list(string)` | Sim         | Lista de actions IAM permitidas (`Effect: Allow`) na policy.                                   |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs de recursos permitidos (`Effect: Allow`) na policy.                               |

## Outputs

| Nome          | Descricao                              |
|---------------|------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.               |
| `policy_arn`  | ARN da IAM Policy criada.                |
| `policy_id`   | ID da IAM Policy criada.                 |
| `role_name`   | Nome da IAM Role criada.                 |
| `role_arn`    | ARN da IAM Role criada.                  |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./terraform/ia-com-contexto/exec-xx/iam"

  environment            = "dev"
  system                 = "tcc"
  region                 = "us-east-1"
  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/app-role"

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
