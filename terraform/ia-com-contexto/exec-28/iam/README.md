# IAM Policy anexada a IAM Role

## Visao geral

Este template cria uma IAM Policy de minimo privilegio e uma IAM Role dedicada,
anexando a policy a role (a policy nunca fica solta, sem principal associado).

Caracteristicas de seguranca aplicadas por padrao:

- a trust policy (assume role policy) da IAM Role restringe `Principal` a um
  unico ARN configuravel (`var.trusted_principal_arn`), proibindo `"*"`;
- nenhuma statement combina `Action: "*"` com `Resource: "*"` (validado via
  `lifecycle.precondition` no `main.tf`);
- o `Effect: Allow` da policy e restrito exatamente as acoes e recursos
  informados pelas variaveis `allowed_actions` e `allowed_resources`;
- nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e
  anexada ou replicada;
- nomenclatura e tags seguem o padrao organizacional
  `<ambiente>-<sistema>-<recurso>-<finalidade>`.

## Variaveis

| Nome                    | Tipo           | Obrigatoria | Descricao                                                                 |
|-------------------------|----------------|-------------|----------------------------------------------------------------------------|
| `environment`           | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                           |
| `system`                | `string`       | Sim         | Nome curto do sistema dono do recurso.                                    |
| `region`                | `string`       | Nao         | Regiao AWS do provider. Padrao: `us-east-1`.                               |
| `additional_tags`       | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.          |
| `policy_name`           | `string`       | Sim         | Finalidade da policy/role, usada no padrao de nomenclatura.                |
| `allowed_actions`       | `list(string)` | Sim         | Acoes IAM permitidas na policy.                                           |
| `allowed_resources`     | `list(string)` | Sim         | ARNs/recursos permitidos na policy.                                       |
| `trusted_principal_arn` | `string`       | Sim         | ARN unico autorizado a assumir a role (`sts:AssumeRole`). Sem wildcard.    |

## Outputs

| Nome          | Descricao                                   |
|---------------|-----------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                     |
| `policy_arn`  | ARN da IAM Policy criada.                      |
| `policy_id`   | ID da IAM Policy criada.                       |
| `role_name`   | Nome da IAM Role criada.                       |
| `role_arn`    | ARN da IAM Role criada.                        |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::prd-tcc-s3-logs",
    "arn:aws:s3:::prd-tcc-s3-logs/*"
  ]

  trusted_principal_arn = "arn:aws:iam::123456789012:role/prd-tcc-app-role"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
