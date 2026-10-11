# IAM Policy anexada a IAM Role

Blueprint Terraform que provisiona uma IAM Policy dedicada e uma IAM Role, com a policy anexada via `aws_iam_role_policy_attachment`. A policy nunca existe "solta": ela é criada e imediatamente associada à role deste módulo.

## O que este módulo cria

- `aws_iam_role.this`: role com trust policy (assume role policy) restrita a uma lista configurável de ARNs de IAM role/user. Não é permitido configurar `"*"` ou um principal de conta inteira (`root`) como trusted principal — isso é bloqueado por `validation` em `variables.tf`.
- `aws_iam_policy.this`: policy com as actions e resources definidos via variáveis. Não é permitido configurar o wildcard total `"*"` em `policy_actions` nem em `policy_resources` — também bloqueado por `validation`.
- `aws_iam_role_policy_attachment.this`: anexa a policy criada à role criada.
- Suporte opcional a `sts:ExternalId` na trust policy (útil em cenários cross-account) via `external_id`.
- Suporte opcional a `permissions_boundary` na role.
- Tags aplicadas tanto na role quanto na policy via `tags`.

## Postura de segurança adotada

- A trust policy é restrita por padrão a principals específicos (IAM role/user ARNs), nunca a `"*"` ou a uma conta inteira sem path (`arn:aws:iam::<account-id>:root`).
- As permissões da policy (`policy_actions` e `policy_resources`) seguem o princípio de menor privilégio por padrão (exemplo: leitura em um bucket S3 específico) e não aceitam wildcard total.
- Nenhuma credencial ou valor sensível é fixado no código; tudo é parametrizado via variáveis.
- `max_session_duration` tem limites validados (3600–43200 segundos, conforme limites da AWS).

## Uso

```hcl
module "iam_role_with_policy" {
  source = "./"

  role_name   = "app-readonly-s3-role"
  policy_name = "app-readonly-s3-policy"

  trusted_principal_arns = [
    "arn:aws:iam::111122223333:role/ci-deployer"
  ]

  policy_actions   = ["s3:GetObject", "s3:ListBucket"]
  policy_resources = [
    "arn:aws:s3:::minha-aplicacao-bucket",
    "arn:aws:s3:::minha-aplicacao-bucket/*"
  ]

  tags = {
    Environment = "staging"
    Owner       = "plataforma"
  }
}
```

## Principais variáveis

| Nome | Descrição | Default |
|---|---|---|
| `role_name` | Nome da IAM Role | `example-restricted-role` |
| `trusted_principal_arns` | ARNs autorizados a assumir a role (não aceita `*`/root) | ARN de exemplo |
| `external_id` | External ID opcional na trust policy | `""` |
| `permissions_boundary_arn` | ARN opcional de permissions boundary | `null` |
| `policy_name` | Nome da IAM Policy | `example-restricted-policy` |
| `policy_actions` | Actions permitidas (não aceita `*`) | `["s3:GetObject", "s3:ListBucket"]` |
| `policy_resources` | Resources permitidos (não aceita `*`) | ARNs de exemplo em S3 |
| `max_session_duration` | Duração máxima da sessão assumida | `3600` |
| `tags` | Tags aplicadas aos recursos | `{}` |

## Principais outputs

- `role_name`, `role_arn`, `role_id`, `role_unique_id`
- `policy_name`, `policy_arn`, `policy_id`
- `policy_attachment_id`

## Validação

```bash
terraform init -backend=false
terraform validate
terraform fmt -check
```

Nenhuma credencial real é necessária para `init -backend=false` e `validate`, pois os `data "aws_iam_policy_document"` são renderizados localmente, sem chamadas à API da AWS.
