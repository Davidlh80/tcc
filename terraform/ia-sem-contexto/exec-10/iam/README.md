# IAM Policy anexada a IAM Role

Blueprint Terraform que provisiona uma IAM Policy escopada e uma IAM Role com trust policy restrita, anexando a policy diretamente à role (nenhuma policy fica solta, sem principal associado).

## Recursos criados

- `aws_iam_role.this` — IAM Role com trust policy (`assume_role_policy`) restrita a um único principal configurável via `var.trusted_principal_arn`. Não permite `"*"` nem `AWS: "*"` como principal.
- `aws_iam_policy.this` — IAM Policy com ações e recursos escopados via `var.policy_actions` e `var.policy_resources`. Validações impedem ações ou recursos wildcard amplos (`"*"`).
- `aws_iam_role_policy_attachment.this` — Anexa a policy à role, garantindo que a policy tenha um principal associado.

## Decisões de segurança

- A trust policy (`data.aws_iam_policy_document.assume_role`) aceita apenas um principal explícito (conta, usuário ou role IAM), nunca `"*"`.
- As permissões da policy (`data.aws_iam_policy_document.scoped`) são restritas por padrão a ações de leitura de um bucket S3 específico, evitando permissões administrativas.
- Validações de variáveis bloqueiam o uso de `"*"` em `policy_actions`, `policy_resources` e `trusted_principal_arn`.
- Nenhuma credencial real é necessária para `terraform validate`; o provider usa apenas a região (`var.aws_region`).

## Uso

```
terraform init -backend=false
terraform validate
```

Para aplicar em um ambiente real, defina ao menos `trusted_principal_arn` com o ARN do principal autorizado a assumir a role:

```
terraform apply \
  -var="trusted_principal_arn=arn:aws:iam::123456789012:role/ci-deployer" \
  -var='policy_actions=["s3:GetObject","s3:ListBucket"]' \
  -var='policy_resources=["arn:aws:s3:::meu-bucket","arn:aws:s3:::meu-bucket/*"]'
```

## Inputs principais

| Nome | Descrição | Default |
|---|---|---|
| `role_name` | Nome da IAM Role | `example-scoped-role` |
| `trusted_principal_arn` | ARN do principal autorizado a assumir a role (obrigatório) | — |
| `policy_name` | Nome da IAM Policy | `example-scoped-policy` |
| `policy_actions` | Ações permitidas pela policy | `["s3:GetObject", "s3:ListBucket"]` |
| `policy_resources` | Recursos alvo das ações | `["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]` |
| `max_session_duration` | Duração máxima da sessão assumida (segundos) | `3600` |
| `tags` | Tags aplicadas aos recursos | `{}` |

## Outputs principais

| Nome | Descrição |
|---|---|
| `role_arn` | ARN da IAM Role criada |
| `policy_arn` | ARN da IAM Policy criada |
| `role_policy_attachment_id` | ID do attachment entre role e policy |
