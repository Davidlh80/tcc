# IAM Role + Policy — p26

Template Terraform que cria uma IAM Policy de menor privilégio anexada a uma IAM Role com trust policy restrita.

> Template gerado com assistência de IA (Claude), com autorização do instrutor.

## Recursos criados

| Recurso | Finalidade |
|---|---|
| `aws_iam_policy` | Permissões explícitas (ações e ARNs informados) |
| `aws_iam_role` | Role com trust policy restrita a principais configurados |
| `aws_iam_role_policy_attachment` | Anexa a policy à role |

## Salvaguardas

- `allowed_actions` rejeita `*` e `servico:*`.
- `allowed_resources` rejeita `*`.
- `trusted_principal_identifiers` rejeita `*`.

## Variáveis

| Nome | Tipo | Padrão | Descrição |
|---|---|---|---|
| `region` | `string` | `us-east-1` | Região AWS |
| `environment` | `string` | — | `dev`, `hml` ou `prod` |
| `policy_name` | `string` | — | Nome da policy |
| `role_name` | `string` | — | Nome da role |
| `trusted_principal_type` | `string` | `Service` | `Service` ou `AWS` |
| `trusted_principal_identifiers` | `list(string)` | `["ec2.amazonaws.com"]` | Quem pode assumir a role |
| `allowed_actions` | `list(string)` | — | Ações permitidas |
| `allowed_resources` | `list(string)` | — | ARNs permitidos |
| `tags` | `map(string)` | `{}` | Tags adicionais |

## Outputs

`policy_name`, `policy_arn`, `policy_id`, `role_name`, `role_arn`.

## Uso

```bash
terraform init
terraform validate
terraform plan \
  -var="environment=dev" \
  -var="policy_name=p26-dev-s3-read" \
  -var="role_name=p26-dev-app" \
  -var='allowed_actions=["s3:GetObject","s3:ListBucket"]' \
  -var='allowed_resources=["arn:aws:s3:::meu-bucket","arn:aws:s3:::meu-bucket/*"]'
```
