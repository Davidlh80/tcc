# IAM Role + IAM Policy (Terraform)

Blueprint Terraform para provisionar uma IAM Role e uma IAM Policy gerenciada anexada a ela, seguindo o principio de menor privilegio. A policy nunca fica solta: ela e criada e imediatamente anexada a role via `aws_iam_role_policy_attachment`.

## Recursos criados

- `aws_iam_role.this` — IAM Role com trust policy restrita aos service principals informados.
- `aws_iam_policy.this` — IAM Policy gerenciada com as actions e recursos definidos pelo usuario.
- `aws_iam_role_policy_attachment.this` — Anexa a policy criada a role criada.
- `data.aws_iam_policy_document.trust` — Trust policy (assume role) da role.
- `data.aws_iam_policy_document.permissions` — Documento de permissoes da policy.

## Decisoes de seguranca por padrao

- O trust policy so permite `sts:AssumeRole` para os principals definidos em `trusted_principal_services` (padrao: `ec2.amazonaws.com`). Nenhum principal `*` (qualquer conta/qualquer principal) e utilizado.
- E possivel restringir ainda mais o trust policy via `trust_condition_source_account` e `trust_condition_source_arn`, mitigando o problema de "confused deputy" em servicos como Lambda e API Gateway.
- `policy_actions` nao aceita o wildcard `"*"`, forcando a listagem explicita das actions necessarias.
- `policy_resources` deve ser explicitado pelo usuario; os valores padrao sao apenas placeholders de exemplo (bucket S3 fictício) e devem ser substituidos pelos ARNs reais do ambiente de destino.
- Suporte opcional a `permissions_boundary_arn` para reforcar o teto maximo de permissoes da role.
- `max_session_duration` e limitado ao intervalo permitido pela AWS (3600 a 43200 segundos).
- Nenhum valor sensivel ou credencial real e utilizado ou exigido; a validacao sintatica (`terraform validate`) nao depende de acesso a conta AWS.

## Uso

```
terraform init -backend=false
terraform validate
```

Para aplicar em um ambiente real, defina as variaveis conforme o caso de uso, por exemplo:

```
role_name                  = "meu-app-role"
policy_name                 = "meu-app-policy"
trusted_principal_services = ["lambda.amazonaws.com"]
trust_condition_source_account = "123456789012"
policy_actions              = ["s3:GetObject", "s3:ListBucket"]
policy_resources            = ["arn:aws:s3:::meu-bucket", "arn:aws:s3:::meu-bucket/*"]
tags = {
  environment = "production"
  owner       = "time-plataforma"
}
```

## Inputs principais

| Nome | Descricao | Padrao |
|---|---|---|
| `aws_region` | Regiao AWS do provider | `us-east-1` |
| `role_name` | Nome da IAM Role | `app-role` |
| `policy_name` | Nome da IAM Policy | `app-policy` |
| `trusted_principal_services` | Service principals autorizados a assumir a role | `["ec2.amazonaws.com"]` |
| `policy_actions` | Actions permitidas pela policy | `["s3:GetObject", "s3:ListBucket"]` |
| `policy_resources` | Recursos (ARNs) alvo das actions | placeholder de exemplo (deve ser sobrescrito) |
| `permissions_boundary_arn` | ARN opcional de permissions boundary | `null` |
| `max_session_duration` | Duracao maxima de sessao (segundos) | `3600` |
| `tags` | Tags aplicadas aos recursos | `{}` |

## Outputs principais

| Nome | Descricao |
|---|---|
| `role_arn` | ARN da IAM Role criada |
| `role_name` | Nome da IAM Role criada |
| `policy_arn` | ARN da IAM Policy criada |
| `policy_name` | Nome da IAM Policy criada |
| `role_policy_attachment_id` | ID do attachment entre role e policy |

## Observacoes

- Este blueprint nao define backend remoto; o estado e mantido localmente por padrao.
- Ajuste `policy_actions` e `policy_resources` para o menor conjunto de permissoes necessario ao caso de uso real antes de aplicar em producao.
