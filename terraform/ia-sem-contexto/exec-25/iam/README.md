# IAM Role + IAM Policy (Terraform)

Blueprint Terraform para provisionar uma IAM Role na AWS com uma IAM Policy de permissoes minimas anexada explicitamente via `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela e sempre criada e anexada na mesma execucao, ao mesmo `aws_iam_role.this`.

## Decisoes de seguranca adotadas

- **Sem wildcard total**: as variaveis `policy_actions` e `policy_resources` rejeitam o valor `"*"` via `validation`, forcando a definicao de actions e recursos explicitos (least privilege).
- **Principal de confianca obrigatorio**: um `lifecycle.precondition` na role garante que pelo menos um principal (service principal ou ARN de conta/role) seja informado antes de criar a trust policy, evitando uma role sem `assume_role_policy` util.
- **Suporte a cross-account seguro**: variavel opcional `external_id`, aplicada como condicao `sts:ExternalId` quando um ARN de conta externa e usado como principal.
- **Permissions boundary opcional**: variavel `permissions_boundary_arn` permite reforcar o limite maximo de permissoes da role quando a organizacao exigir.
- **Sessao limitada**: `max_session_duration` validado entre 3600 e 43200 segundos (limites da API IAM).
- **Tags padronizadas**: todas as tags informadas em `tags` sao mescladas com uma tag `ManagedBy = terraform` e uma tag `Name` derivada de `name_prefix`.

## Recursos criados

| Recurso | Descricao |
|---|---|
| `aws_iam_role.this` | Role IAM com trust policy baseada em `trusted_service_principals` e/ou `trusted_principal_arns`. |
| `aws_iam_policy.this` | Policy IAM com as `policy_actions` permitidas sobre os `policy_resources`. |
| `aws_iam_role_policy_attachment.this` | Anexa a policy diretamente a role criada. |

## Uso basico

```hcl
module "iam_role" {
  source = "./"

  name_prefix                = "minha-app"
  trusted_service_principals = ["lambda.amazonaws.com"]

  policy_actions = [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
  ]

  policy_resources = [
    "arn:aws:logs:us-east-1:123456789012:log-group:/aws/lambda/minha-app:*",
  ]

  tags = {
    Ambiente = "producao"
    Time     = "plataforma"
  }
}
```

## Variaveis principais

- `name_prefix`: prefixo usado no nome da role e da policy.
- `trusted_service_principals` / `trusted_principal_arns`: definem quem pode assumir a role (ao menos um deve ser preenchido).
- `external_id`: opcional, recomendado em cenarios de acesso cross-account por terceiros.
- `policy_actions` / `policy_resources`: escopo de permissoes concedido pela policy (sem wildcard total).
- `permissions_boundary_arn`: ARN opcional de permissions boundary.
- `max_session_duration`: duracao maxima de sessao assumida, em segundos.
- `tags`: tags adicionais aplicadas aos recursos.

## Outputs

- `role_arn`, `role_name`, `role_unique_id`
- `policy_arn`, `policy_name`, `policy_attachment_id`
- `account_id`

## Validacao local

```bash
terraform fmt
terraform init -backend=false
terraform validate
```

Nenhum backend remoto e nenhuma credencial real sao necessarios para `init`/`validate`; apenas o schema do provider AWS e utilizado.
