# IAM Role com IAM Policy Anexada

Blueprint Terraform que provisiona uma IAM Role e uma IAM Policy customizada, anexando a policy diretamente a role (nenhum recurso fica solto sem principal associado).

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role) restrita a um unico principal de servico AWS.
- `aws_iam_policy.this` — policy gerenciada com acoes e recursos explicitos (sem wildcard total).
- `aws_iam_role_policy_attachment.this` — anexa a policy customizada a role.

## Decisões de segurança

- **Sem wildcards totais**: `allowed_actions` e `allowed_resources` rejeitam o valor `"*"` via `validation`, forçando o consumidor do modulo a declarar acoes e recursos explicitos (principio do menor privilegio).
- **Trust policy restrita**: a role so pode ser assumida pelo principal de servico definido em `trusted_principal_service` (ex.: `ec2.amazonaws.com`), nunca por `"*"` ou por uma conta arbitraria.
- **Sem credenciais fixas**: nenhum valor sensivel (chaves, segredos, ARNs de conta reais) esta hardcoded; tudo é parametrizavel via variaveis com defaults ilustrativos.
- **Policy nunca solta**: a `aws_iam_policy` é criada e imediatamente anexada à role via `aws_iam_role_policy_attachment`, garantindo que sempre exista um principal associado.
- **force_detach_policies = true**: evita que a role fique com policies orfãs impedindo sua destruição.

## Variaveis principais

| Nome | Descrição | Default |
|---|---|---|
| `role_name` | Nome da IAM Role | `app-role` |
| `policy_name` | Nome da IAM Policy | `app-policy` |
| `trusted_principal_service` | Principal de serviço autorizado a assumir a role | `ec2.amazonaws.com` |
| `allowed_actions` | Ações permitidas pela policy | `["s3:GetObject", "s3:ListBucket"]` |
| `allowed_resources` | Recursos (ARNs) aos quais as ações se aplicam | bucket S3 de exemplo |
| `max_session_duration` | Duração máxima da sessão assumida (segundos) | `3600` |
| `tags` | Tags aplicadas aos recursos | `{}` |

Veja `variables.tf` para a lista completa, incluindo `path`, `role_description` e `policy_description`.

## Outputs

- `role_arn`, `role_name`, `role_id`
- `policy_arn`, `policy_name`
- `policy_attachment_id`

## Uso

```
module "iam_role_with_policy" {
  source = "./"

  role_name                 = "minha-app-role"
  policy_name                = "minha-app-policy"
  trusted_principal_service  = "lambda.amazonaws.com"
  allowed_actions             = ["dynamodb:GetItem", "dynamodb:PutItem"]
  allowed_resources           = ["arn:aws:dynamodb:us-east-1:123456789012:table/minha-tabela"]

  tags = {
    Ambiente = "producao"
    Time     = "plataforma"
  }
}
```

## Validação local

```
terraform init -backend=false
terraform validate
terraform fmt -check
```

Nenhum recurso depende de credenciais reais ou de backend remoto para essas verificações sintáticas.

## Extensões recomendadas

- Para cenarios cross-account, adicione uma condicao `sts:ExternalId` na trust policy.
- Para auditoria, considere anexar tambem uma policy gerenciada da AWS (ex.: `AWSCloudTrail_FullAccess`) apenas se estritamente necessário, sempre com escopo minimo.
- Avalie o uso de `permissions_boundary` na role para reforçar o teto de privilégios em ambientes multi-tenant.
