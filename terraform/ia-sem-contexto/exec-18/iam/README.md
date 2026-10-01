# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Role com uma IAM Policy customer-managed
anexada diretamente a ela (a policy nunca fica solta, sem principal associado).

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role) configuravel.
- `aws_iam_policy.this` — policy customer-managed com actions e resources configuraveis.
- `aws_iam_role_policy_attachment.this` — anexa a policy a role.
- `data.aws_iam_policy_document.assume_role` — documento da trust policy.
- `data.aws_iam_policy_document.this` — documento da policy de permissoes.
- `check.assume_role_principal_required` — valida que ao menos um principal de confianca foi definido.

## Decisoes de seguranca (padrao)

- Nenhum wildcard total (`"*"`) e aceito em `policy_actions` ou `policy_resources` — a validacao das
  variaveis bloqueia esses valores para forcar principio de menor privilegio.
- `require_secure_transport = true` por padrao, adicionando a condicao `aws:SecureTransport = true`
  na policy.
- `require_mfa_for_aws_principals = true` por padrao: quando `trusted_aws_principals` e usado (acesso
  cross-account/usuario), a trust policy exige MFA (`aws:MultiFactorAuthPresent = true`).
- `external_id` disponivel para reforcar o cenario de assume role cross-account com terceiros.
- Nenhum valor sensivel ou credencial real e usado; tudo e parametrizado via variaveis.
- `force_detach_policies = true` na role evita bloqueios acidentais em operacoes de destroy.

## Uso

```
module "iam_role_policy" {
  source = "./"

  name = "minha-app"

  trusted_service_principals = ["lambda.amazonaws.com"]

  policy_actions = [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
  ]

  policy_resources = [
    "arn:aws:logs:us-east-1:123456789012:log-group:/aws/lambda/minha-app:*",
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Variaveis principais

| Nome | Descricao | Default |
|---|---|---|
| `name` | Nome base da role/policy | `"app"` |
| `trusted_service_principals` | Service principals que podem assumir a role | `["ec2.amazonaws.com"]` |
| `trusted_aws_principals` | ARNs de contas/usuarios/roles que podem assumir a role | `[]` |
| `policy_actions` | Actions permitidas pela policy | exemplo de leitura em S3 |
| `policy_resources` | Recursos alvo das actions | exemplo de bucket S3 |
| `require_secure_transport` | Exige TLS na policy | `true` |
| `require_mfa_for_aws_principals` | Exige MFA para principals AWS | `true` |

Veja `variables.tf` para a lista completa, tipos e validacoes.

## Outputs

- `role_name`, `role_arn`, `role_id`
- `policy_name`, `policy_arn`
- `policy_attachment_id`
- `assume_role_policy_json`

## Validacao local (sem credenciais reais)

```
terraform fmt
terraform init -backend=false
terraform validate
```

Nenhum backend remoto e configurado; o estado e local por padrao.
