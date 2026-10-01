# IAM Role com Policy Anexada (Terraform)

Blueprint Terraform para provisionar uma IAM Role na AWS com uma IAM Policy gerenciada anexada diretamente a ela. A policy nunca fica solta: ela e criada e anexada na mesma execucao via `aws_iam_role_policy_attachment`.

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role) configuravel.
- `data.aws_iam_policy_document.assume_role` — documento de confianca (trust policy) baseado em `var.trusted_principal_type` e `var.trusted_principal_identifiers`, com suporte opcional a `sts:ExternalId`.
- `data.aws_iam_policy_document.role_policy` — documento de permissoes com as acoes e recursos configurados.
- `aws_iam_policy.this` — policy gerenciada, sem wildcard `*` em acoes por padrao.
- `aws_iam_role_policy_attachment.this` — anexa a policy a role.

## Postura de seguranca por padrao

- O principal de confianca padrao e um Service principal (`ec2.amazonaws.com`), evitando trust policies abertas para qualquer conta ou usuario.
- Uma validacao bloqueia o uso do wildcard `"*"` isolado em `allowed_actions`, forcando a especificacao de acoes concretas.
- `external_id` (sensivel) pode ser definido para exigir `sts:ExternalId` no assume role, recomendado em cenarios cross-account (`trusted_principal_type = "AWS"`).
- `permissions_boundary_arn` permite aplicar uma permissions boundary opcional a role.
- Nenhum valor sensivel ou credencial real e fixado no codigo; tudo e parametrizado via variaveis.

## Uso

```
module "iam_role_with_policy" {
  source = "./"

  role_name                     = "app-service-role"
  policy_name                   = "app-service-policy"
  trusted_principal_type        = "Service"
  trusted_principal_identifiers = ["lambda.amazonaws.com"]

  allowed_actions = [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
  ]

  resource_arns = [
    "arn:aws:logs:us-east-1:123456789012:log-group:/aws/lambda/app-service:*",
  ]

  tags = {
    Environment = "dev"
    Owner       = "platform-team"
  }
}
```

## Validacao local

```
terraform init -backend=false
terraform validate
terraform fmt -check
```

Nenhum backend remoto e nenhuma credencial real e necessaria para os comandos acima, pois o provider AWS so precisa de configuracao valida de sintaxe (regiao) para `validate`.

## Variaveis principais

| Nome | Descricao | Default |
|---|---|---|
| `role_name` | Nome da IAM Role | `example-app-role` |
| `policy_name` | Nome da IAM Policy | `example-app-policy` |
| `trusted_principal_type` | Tipo do principal (`AWS`, `Service`, `Federated`) | `Service` |
| `trusted_principal_identifiers` | Identificadores do principal confiavel | `["ec2.amazonaws.com"]` |
| `external_id` | External ID opcional para assume role cross-account | `""` |
| `allowed_actions` | Acoes IAM permitidas na policy | `["s3:GetObject", "s3:ListBucket"]` |
| `resource_arns` | ARNs dos recursos alvo da policy | exemplo de bucket S3 |
| `max_session_duration` | Duracao maxima da sessao (segundos) | `3600` |
| `permissions_boundary_arn` | ARN de permissions boundary opcional | `null` |
| `tags` | Tags aplicadas aos recursos | `{ ManagedBy = "terraform" }` |

## Outputs

- `role_arn`, `role_name`, `role_unique_id`
- `policy_arn`, `policy_name`
- `assume_role_policy_json`
