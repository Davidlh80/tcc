# IAM Role com IAM Policy anexada

Blueprint Terraform que provisiona uma IAM Role e uma IAM Policy gerenciada, anexando a policy diretamente a role (nenhuma policy fica solta, sem principal associado).

## Recursos criados

- `data.aws_iam_policy_document.assume_role` — trust policy (assume role) da IAM Role.
- `data.aws_iam_policy_document.permissions` — documento de permissoes da IAM Policy.
- `aws_iam_role.this` — IAM Role.
- `aws_iam_policy.this` — IAM Policy gerenciada.
- `aws_iam_role_policy_attachment.this` — anexa a policy a role.

## Decisoes de seguranca

- Nenhum wildcard total (`"*"`) e permitido em `allowed_actions` nem em `resource_arns`; ambas as variaveis sao validadas para bloquear esse valor.
- O principal de confianca (assume role) e explicito e configuravel via `assume_role_principal_type` e `assume_role_principal_identifiers` — nao ha padrao permissivo do tipo `"AWS": "*"`.
- Suporte opcional a `sts:ExternalId` na trust policy, recomendado para cenarios cross-account.
- Suporte opcional a `permissions_boundary_arn` para limitar o escopo maximo de permissoes da role.
- `force_detach_policies = true` por padrao, evitando bloqueios acidentais na destruicao da role.
- Nenhum valor sensivel ou credencial real e usado; ARNs de exemplo devem ser substituidos pelos recursos reais do consumidor do modulo.

## Uso

```
module "iam_role_with_policy" {
  source = "./"

  role_name                         = "minha-app-role"
  policy_name                       = "minha-app-policy"
  assume_role_principal_type        = "Service"
  assume_role_principal_identifiers = ["lambda.amazonaws.com"]

  allowed_actions = [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
  ]

  resource_arns = [
    "arn:aws:logs:us-east-1:123456789012:log-group:/aws/lambda/minha-app:*",
  ]

  tags = {
    Ambiente = "producao"
  }
}
```

## Inputs principais

| Nome | Descricao | Default |
|---|---|---|
| `aws_region` | Regiao usada pelo provider AWS | `us-east-1` |
| `role_name` | Nome da IAM Role | `app-role` |
| `policy_name` | Nome da IAM Policy | `app-policy` |
| `assume_role_principal_type` | Tipo do principal de confianca (`Service` ou `AWS`) | `Service` |
| `assume_role_principal_identifiers` | Identificadores do principal de confianca | `["ec2.amazonaws.com"]` |
| `assume_role_external_id` | External ID opcional para assume role | `null` |
| `allowed_actions` | Actions permitidas na policy | `["s3:GetObject", "s3:ListBucket"]` |
| `resource_arns` | Recursos alvo das actions | `["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]` |
| `max_session_duration` | Duracao maxima da sessao (segundos) | `3600` |
| `permissions_boundary_arn` | ARN de permissions boundary opcional | `null` |
| `tags` | Tags aplicadas aos recursos | `{ ManagedBy = "terraform" }` |

## Outputs

- `role_name`, `role_arn`, `role_unique_id`
- `policy_name`, `policy_arn`
- `policy_attachment_id`

## Validacao local

```
terraform init -backend=false
terraform validate
```

Nenhum backend remoto e nenhuma credencial real sao necessarios para essas etapas.
