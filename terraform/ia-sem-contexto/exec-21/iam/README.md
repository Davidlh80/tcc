# IAM Role com IAM Policy Anexada

## Objetivo

Provisiona uma IAM Role de proposito especifico com uma IAM Policy dedicada anexada diretamente a ela. A policy nunca existe de forma solta: ela e criada e associada a role na mesma execucao via `aws_iam_role_policy_attachment`.

## Recursos criados

- `aws_iam_role.this`: role com trust policy (assume role) restrita aos service principals informados em `trusted_service_principals`.
- `aws_iam_policy.this`: policy gerenciada com acoes e recursos explicitamente listados (sem wildcard `*` por padrao).
- `aws_iam_role_policy_attachment.this`: anexa a policy criada a role criada.

## Postura de seguranca adotada

- Nenhum wildcard `*` em `Action` por padrao; a validacao de `allowed_actions` bloqueia esse valor.
- Recursos (`Resource`) explicitos por padrao, evitando concessao sobre toda a conta.
- Trust policy exige ao menos um principal de confianca (nao e permitido criar a policy sem um principal associado).
- `max_session_duration` limitado a um intervalo seguro (1h a 12h, conforme limites da AWS).
- Tags aplicadas para rastreabilidade (`ManagedBy = terraform` por padrao).

## Variaveis principais

| Nome | Descricao | Default |
|---|---|---|
| `region` | Regiao AWS do provider | `us-east-1` |
| `role_name` | Nome da IAM Role | `app-scoped-role` |
| `trusted_service_principals` | Principals autorizados a assumir a role | `["ec2.amazonaws.com"]` |
| `policy_name` | Nome da IAM Policy | `app-scoped-policy` |
| `allowed_actions` | Acoes permitidas pela policy | `["s3:GetObject", "s3:ListBucket"]` |
| `allowed_resources` | Recursos (ARNs) permitidos | bucket S3 de exemplo |
| `tags` | Tags aplicadas aos recursos | `{ ManagedBy = "terraform" }` |

Ajuste `trusted_service_principals`, `allowed_actions` e `allowed_resources` conforme o caso de uso real antes de aplicar em um ambiente de producao.

## Uso

```
terraform init -backend=false
terraform validate
terraform plan -var="allowed_resources=[\"arn:aws:s3:::meu-bucket\",\"arn:aws:s3:::meu-bucket/*\"]"
```

## Outputs

- `role_name`, `role_arn`, `role_id`: identificam a role criada.
- `policy_name`, `policy_arn`: identificam a policy criada.
- `policy_attachment_id`: identifica o vinculo entre policy e role.

## Observacoes

- Este blueprint nao depende de credenciais reais para `terraform validate`.
- Nao usa backend remoto.
- Revise `allowed_actions`/`allowed_resources` para o menor privilegio possivel antes de qualquer `apply` em conta real.
