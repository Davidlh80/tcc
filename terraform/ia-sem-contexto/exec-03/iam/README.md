# IAM Role + IAM Policy (anexada)

Blueprint Terraform que provisiona uma IAM Role com uma trust policy (assume role) e uma IAM Policy customizada anexada diretamente a ela via `aws_iam_role_policy_attachment`. A policy nunca fica solta, sem principal associado.

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role) configurável.
- `aws_iam_policy.this` — policy customizada com statements definidos por variável.
- `aws_iam_role_policy_attachment.this` — anexa a policy à role.

## Trust policy (assume role)

Por padrão, apenas o serviço `ec2.amazonaws.com` pode assumir a role (`trusted_service_principals`). É possível:

- Adicionar principais AWS (contas, roles, usuários) via `trusted_aws_principals`.
- Exigir `sts:ExternalId` ao usar `trusted_aws_principals`, definindo `external_id` (recomendado para acesso cross-account de terceiros).

Pelo menos um principal (serviço ou AWS) deve resultar da combinação das variáveis; o padrão já garante isso via `trusted_service_principals`.

## Permissões (policy)

`policy_statements` define os statements da policy anexada. O padrão inclui um exemplo de leitura restrita a um bucket S3 fictício (`example-bucket`), sem uso de wildcard em `actions` ou `resources`. Validações de variável bloqueiam `*` em `actions`/`resources` e exigem `effect` igual a `Allow` ou `Deny`.

Ajuste `policy_statements` para o caso de uso real, mantendo o princípio de menor privilégio (ações e recursos específicos, evitando `*`).

## Uso

```
terraform init -backend=false
terraform validate
terraform plan \
  -var 'role_name=minha-role' \
  -var 'policy_name=minha-policy' \
  -var 'trusted_service_principals=["lambda.amazonaws.com"]' \
  -var 'policy_statements=[{sid="AllowLogs",effect="Allow",actions=["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"],resources=["arn:aws:logs:us-east-1:123456789012:log-group:/app/*"]}]'
```

## Inputs principais

| Nome | Descrição | Padrão |
|---|---|---|
| `aws_region` | Região usada pelo provider | `us-east-1` |
| `role_name` | Nome da IAM Role | `app-role` |
| `policy_name` | Nome da IAM Policy | `app-policy` |
| `trusted_service_principals` | Serviços autorizados a assumir a role | `["ec2.amazonaws.com"]` |
| `trusted_aws_principals` | ARNs adicionais autorizados a assumir a role | `[]` |
| `external_id` | External ID exigido em cross-account | `""` |
| `max_session_duration` | Duração máxima da sessão (segundos) | `3600` |
| `permissions_boundary_arn` | ARN de permissions boundary opcional | `""` |
| `policy_statements` | Statements da policy anexada | ver `variables.tf` |
| `tags` | Tags para role e policy | `{}` |

## Outputs

`role_arn`, `role_name`, `role_id`, `policy_arn`, `policy_name`, `policy_attachment_id`.

## Segurança

- Sem valores de credenciais reais ou fixos no código.
- Sem wildcards (`*`) em actions/resources por padrão, reforçado por validações de variável.
- Suporte a `permissions_boundary` e `sts:ExternalId` para reforçar controles em cenários cross-account.
- `force_detach_policies = true` evita bloqueios ao destruir a role.
- Sem backend remoto; validação sintática funciona com `terraform init -backend=false` e `terraform validate`, sem credenciais AWS reais.
