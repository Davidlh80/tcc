# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template provisiona uma IAM Policy customizada anexada a uma IAM Role, seguindo o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` da organizacao (ex.: `dev-tcc-iam-readonly`).

Caracteristicas de seguranca aplicadas por padrao:

- a IAM Policy nunca fica solta: e sempre criada e anexada a uma IAM Role via `aws_iam_role_policy_attachment`;
- a trust policy (assume role policy) da role restringe o principal a uma lista de ARNs especificos informada em `trusted_principal_arns`; `"Principal": "*"` ou `"AWS": "*"` nao sao permitidos;
- a unica statement de permissao da policy usa `Effect: Allow` restrito exatamente as actions e aos recursos informados nas variaveis `allowed_actions` e `allowed_resources`;
- e proibido, por validacao de variavel, combinar `Action: "*"` com `Resource: "*"` na mesma statement;
- nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada;
- todas as tags obrigatorias da organizacao sao aplicadas na Role e na Policy.

## 2. Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|---|---|---|---|
| `environment` | `string` | Sim | Ambiente de implantacao (`dev`, `hml` ou `prd`). |
| `system` | `string` | Sim | Nome do sistema/aplicacao, usado na nomenclatura padronizada. |
| `region` | `string` | Sim | Regiao AWS usada pelo provider. |
| `additional_tags` | `map(string)` | Nao (default `{}`) | Tags adicionais mescladas as tags obrigatorias. |
| `policy_name` | `string` | Sim | Finalidade da IAM Policy/Role, usada para compor o nome padronizado. |
| `allowed_actions` | `list(string)` | Sim | Actions IAM permitidas na policy (menor privilegio). |
| `allowed_resources` | `list(string)` | Sim | ARNs/recursos aos quais as actions permitidas se aplicam. |
| `trusted_principal_arns` | `list(string)` | Sim | ARNs de principals autorizados a assumir a role (nunca `"*"`). |
| `max_session_duration` | `number` | Nao (default `3600`) | Duracao maxima da sessao assumida, em segundos (3600-43200). |

## 3. Outputs

| Nome | Descricao |
|---|---|
| `policy_name` | Nome da IAM Policy criada. |
| `policy_arn` | ARN da IAM Policy criada. |
| `policy_id` | ID da IAM Policy criada. |
| `role_name` | Nome da IAM Role criada e associada a policy. |
| `role_arn` | ARN da IAM Role criada e associada a policy. |
| `role_id` | ID da IAM Role criada e associada a policy. |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./iam"

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

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/dev-tcc-ec2-app"
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
