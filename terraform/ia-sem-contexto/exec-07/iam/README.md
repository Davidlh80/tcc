# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Policy e uma IAM Role na AWS, com a policy anexada à role por meio de `aws_iam_role_policy_attachment`. A policy nunca permanece solta: ela é sempre criada em conjunto com a role e o attachment que as vincula.

## Recursos criados

- `aws_iam_role.this` — Role com trust policy (assume role policy) restrita a um único principal configurável.
- `aws_iam_policy.this` — Policy com permissões explícitas, sem ações administrativas amplas nem wildcard `"*"` em `Action`.
- `aws_iam_role_policy_attachment.this` — Attachment que vincula a policy à role.

## Segurança por padrão

- A trust policy (`data.aws_iam_policy_document.assume_role`) aceita exatamente um principal do tipo `AWS`, definido por `var.trusted_principal_arn`. Uma validação impede que esse valor seja `"*"` ou um ARN fora do formato esperado (`arn:aws:iam::<account-id>:role|user|root/...`).
- A policy de permissões (`data.aws_iam_policy_document.permissions`) usa `var.allowed_actions` e `var.resource_arns`, ambos validados para impedir listas vazias e o wildcard `"*"` em `Action`.
- Nenhuma credencial real é necessária para `terraform init -backend=false` e `terraform validate`, pois o módulo não depende de data sources que exijam chamadas à AWS.

## Variáveis obrigatórias

- `trusted_principal_arn` — ARN do principal autorizado a assumir a role.
- `resource_arns` — ARNs dos recursos sobre os quais as ações serão permitidas.

## Variáveis com valores padrão

Demais variáveis (`aws_region`, `role_name`, `policy_name`, `allowed_actions`, `max_session_duration`, `path`, `force_detach_policies`, `tags`, etc.) possuem valores padrão seguros e podem ser sobrescritas conforme a necessidade de cada ambiente.

## Uso

```
terraform init -backend=false
terraform validate
terraform plan \
  -var="trusted_principal_arn=arn:aws:iam::123456789012:role/exemplo" \
  -var='resource_arns=["arn:aws:s3:::meu-bucket/*"]'
```

## Outputs

- `role_name`, `role_arn`, `role_id`
- `policy_name`, `policy_arn`
- `policy_attachment_id`
