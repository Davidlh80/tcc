# IAM Role + IAM Policy (Terraform Blueprint)

Blueprint Terraform para provisionar uma IAM Role na AWS com uma IAM Policy
gerenciada anexada a ela via `aws_iam_role_policy_attachment`. A policy nunca
existe desacoplada de um principal: ela e sempre criada e anexada na mesma
aplicacao.

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role policy) configuravel.
- `aws_iam_policy.this` — policy gerenciada com acoes e recursos definidos por variavel.
- `aws_iam_role_policy_attachment.this` — anexa a policy a role.

## Decisoes de seguranca por padrao

- `allowed_actions` e obrigatoria e rejeita o wildcard total `"*"` via `validation`,
  forcando a definicao explicita de acoes (least privilege).
- `permissions_boundary_arn` e suportado (opcional) para reforcar o limite maximo
  de permissoes da role.
- `external_id` permite exigir um External ID na assume role policy, mitigando
  o problema do "confused deputy" em cenarios de acesso cross-account.
- `trusted_principal_type` e `trusted_principal_identifiers` tornam o principal
  de confianca explicito e obrigatorio — nao ha wildcard de principal (`"*"`).
- `max_session_duration` e limitado entre 3600 e 43200 segundos (limites validos da AWS).
- Nenhum valor sensivel (account ID, ARNs reais, credenciais) esta hardcoded;
  tudo e parametrizado via `variables.tf`.

## Uso

```
module "iam_role_with_policy" {
  source = "./"

  role_name   = "app-service-role"
  policy_name = "app-service-policy"

  trusted_principal_type        = "Service"
  trusted_principal_identifiers = ["lambda.amazonaws.com"]

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*",
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Variaveis principais

| Nome | Descricao | Default |
|---|---|---|
| `role_name` | Nome da IAM Role | `example-role` |
| `policy_name` | Nome da IAM Policy | `example-policy` |
| `trusted_principal_type` | Tipo do principal (`Service`, `AWS`, `Federated`) | `Service` |
| `trusted_principal_identifiers` | Identificadores do principal confiavel | `["lambda.amazonaws.com"]` |
| `allowed_actions` | Acoes IAM permitidas (obrigatorio, sem `"*"`) | — |
| `allowed_resources` | ARNs dos recursos alvo (obrigatorio) | — |
| `permissions_boundary_arn` | ARN da permissions boundary | `null` |
| `external_id` | External ID exigido na assume role | `null` |
| `max_session_duration` | Duracao maxima da sessao (segundos) | `3600` |
| `tags` | Tags aplicadas aos recursos | `{}` |

## Outputs

- `role_arn`, `role_name`, `role_unique_id`
- `policy_arn`, `policy_id`, `policy_name`
- `role_policy_attachment_id`

## Validacao local

```
terraform init -backend=false
terraform validate
```

Nao ha backend remoto configurado e nenhuma credencial real e necessaria para
`init`/`validate`. Para `plan`/`apply`, forneca `allowed_actions` e
`allowed_resources` (variaveis sem default) e credenciais AWS validas.
