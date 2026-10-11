# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Role com uma trust policy (assume role policy) restrita a um unico principal configuravel, e uma IAM Policy com permissoes especificas anexada diretamente a essa role por meio de `aws_iam_role_policy_attachment`. A policy nunca existe desvinculada de um principal: ela e criada e anexada na mesma execucao.

## Recursos criados

- `aws_iam_role.this`: role com `assume_role_policy` gerada a partir de `data.aws_iam_policy_document.assume_role`, restrita ao principal definido em `var.trusted_principal_arn`.
- `aws_iam_policy.this`: policy gerada a partir de `data.aws_iam_policy_document.permissions`, limitada as actions e recursos definidos em `var.allowed_actions` e `var.resource_arns`.
- `aws_iam_role_policy_attachment.this`: anexa a policy criada a role criada.

## Decisoes de seguranca

- A trust policy aceita apenas um principal especifico (conta, usuario ou role); `"*"` ou ARNs que representem qualquer conta sao bloqueados por validacao da variavel `trusted_principal_arn`.
- `allowed_actions` nao pode conter o wildcard `*` nem `iam:*`, evitando permissoes administrativas amplas.
- `resource_arns` nao pode conter `*`, exigindo escopo explicito de recursos.
- Nenhuma credencial ou valor sensivel real e utilizado; os valores padrao sao exemplos ilustrativos (`123456789012` e o ID de conta de exemplo padrao da documentacao da AWS).
- Tags sao aplicadas tanto na role quanto na policy para rastreabilidade.

## Uso

```
terraform init -backend=false
terraform validate
```

Para provisionar de fato, ajuste `trusted_principal_arn`, `allowed_actions` e `resource_arns` para os valores reais do seu ambiente antes de executar `terraform plan`/`terraform apply` com credenciais validas.

## Inputs principais

| Nome | Descricao | Default |
|---|---|---|
| `aws_region` | Regiao do provider AWS | `us-east-1` |
| `role_name` | Nome da IAM Role | `example-restricted-role` |
| `policy_name` | Nome da IAM Policy | `example-least-privilege-policy` |
| `trusted_principal_arn` | ARN do principal autorizado a assumir a role | ARN de exemplo |
| `allowed_actions` | Actions permitidas na policy | `["s3:GetObject", "s3:ListBucket"]` |
| `resource_arns` | Recursos aos quais as actions se aplicam | `["arn:aws:s3:::example-bucket/*"]` |
| `max_session_duration` | Duracao maxima da sessao assumida (segundos) | `3600` |
| `tags` | Tags aplicadas aos recursos | `{ ManagedBy = "terraform" }` |

## Outputs

| Nome | Descricao |
|---|---|
| `role_name` | Nome da IAM Role criada |
| `role_arn` | ARN da IAM Role criada |
| `role_id` | ID unico da IAM Role criada |
| `policy_name` | Nome da IAM Policy criada |
| `policy_arn` | ARN da IAM Policy criada |
| `policy_attachment_id` | ID do attachment entre role e policy |
