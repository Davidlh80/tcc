# IAM Policy anexada a IAM Role

## Visao geral

Este template cria uma IAM Policy de menor privilegio anexada a uma IAM Role dedicada, seguindo os padroes organizacionais de nomenclatura, tags e governanca.

Recursos criados:

- `aws_iam_role.this`: Role cuja trust policy (assume role policy) restringe o principal autorizado a assumir a role a um unico ARN configuravel (`var.trusted_principal_arn`), proibindo `Principal: "*"`.
- `aws_iam_policy.this`: Policy com uma unica statement `Effect: Allow`, restrita exatamente as acoes (`var.allowed_actions`) e recursos (`var.allowed_resources`) informados por variavel.
- `aws_iam_role_policy_attachment.this`: Anexa a policy a role, garantindo que a policy nunca fique solta, sem principal associado.

Controles de seguranca aplicados:

- Proibido `Principal: "*"` ou `"AWS": "*"` na trust policy (validado via regex do ARN em `trusted_principal_arn`).
- Proibida, via `lifecycle.precondition`, uma statement que combine `Action: "*"` com `Resource: "*"` na mesma regra.
- `Effect: Allow` restrito apenas as acoes e recursos informados pelas variaveis `allowed_actions` e `allowed_resources`.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- Nomenclatura dos recursos segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`.
- Tags obrigatorias da organizacao aplicadas em todos os recursos que suportam tags.

## Variaveis

| Nome                    | Tipo           | Obrigatoria | Descricao                                                                              |
|-------------------------|----------------|-------------|------------------------------------------------------------------------------------------|
| `environment`           | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                        |
| `system`                | `string`       | Sim         | Nome do sistema/aplicacao ao qual os recursos pertencem.                                |
| `region`                | `string`       | Nao         | Regiao AWS do provider. Padrao: `us-east-1`.                                            |
| `additional_tags`       | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.                       |
| `policy_name`           | `string`       | Sim         | Finalidade/sufixo que identifica a IAM Policy e a IAM Role.                             |
| `trusted_principal_arn` | `string`       | Sim         | ARN unico do principal autorizado a assumir a Role. Nao pode ser `*`.                    |
| `allowed_actions`       | `list(string)` | Sim         | Lista de acoes IAM permitidas (`Effect: Allow`) na policy.                              |
| `allowed_resources`     | `list(string)` | Sim         | Lista de recursos (ARNs) permitidos (`Effect: Allow`) na policy.                        |

## Outputs

| Nome          | Descricao                              |
|---------------|-----------------------------------------|
| `policy_name` | Nome da IAM Policy criada.              |
| `policy_arn`  | ARN da IAM Policy criada.               |
| `policy_id`   | ID da IAM Policy criada.                |
| `role_name`   | Nome da IAM Role criada.                |
| `role_arn`    | ARN da IAM Role criada.                 |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment            = "dev"
  system                 = "tcc"
  region                 = "us-east-1"
  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/app-execution-role"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*",
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
