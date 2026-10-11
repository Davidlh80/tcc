# IAM Policy anexada a IAM Role (blueprint)

Blueprint Terraform que provisiona:

- Uma **IAM Policy** com permissoes restritas (sem acoes administrativas, sem `Action = "*"` e sem `Resource = "*"` amplo). No exemplo padrao, a policy permite apenas escrever logs no CloudWatch Logs, escopada a conta, regiao e prefixo de log group configuraveis.
- Uma **IAM Role** com uma **trust policy (assume role policy)** restrita a um ou mais principais configuraveis via `trusted_principal_arns`. A trust policy nunca aceita `"*"` como principal — isso e validado explicitamente na variavel.
- Um **anexo (`aws_iam_role_policy_attachment`)** entre a policy e a role, garantindo que a policy nunca fique solta sem nenhum principal associado.

## Decisoes de seguranca

- **Sem wildcard em principal da trust policy**: `trusted_principal_arns` possui validacao que rejeita lista vazia e rejeita o valor `"*"`.
- **Sem permissoes administrativas**: a policy padrao concede apenas `logs:CreateLogGroup`, `logs:CreateLogStream` e `logs:PutLogEvents`, escopadas por ARN (conta, regiao e prefixo de log group).
- **ExternalId opcional**: `assume_role_external_id` permite mitigar o problema do "confused deputy" ao assumir a role entre contas.
- **`max_session_duration` limitado**: validado entre 900 e 43200 segundos (limites da API IAM).
- **Tags configuraveis**: aplicadas tanto na role quanto na policy via `tags`.

## Uso

```hcl
module "scoped_role" {
  source = "./"

  role_name   = "app-log-writer"
  policy_name = "app-log-writer-policy"

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/ci-deployer",
  ]

  assume_role_external_id          = "optional-external-id"
  cloudwatch_log_group_name_prefix = "/app/production/"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Inputs

| Nome | Descricao | Tipo | Default |
|---|---|---|---|
| `aws_region` | Regiao AWS usada pelo provider | `string` | `"us-east-1"` |
| `role_name` | Nome da IAM Role | `string` | `"example-scoped-role"` |
| `role_description` | Descricao da IAM Role | `string` | ver `variables.tf` |
| `max_session_duration` | Duracao maxima da sessao assumida (segundos) | `number` | `3600` |
| `policy_name` | Nome da IAM Policy | `string` | `"example-scoped-policy"` |
| `policy_description` | Descricao da IAM Policy | `string` | ver `variables.tf` |
| `trusted_principal_arns` | ARNs autorizados a assumir a role (sem `"*"`) | `list(string)` | obrigatorio |
| `assume_role_external_id` | ExternalId exigido na trust policy (opcional) | `string` | `null` |
| `cloudwatch_log_group_name_prefix` | Prefixo de log group permitido para escrita | `string` | `"/example-app/"` |
| `tags` | Tags aplicadas aos recursos | `map(string)` | `{}` |

## Outputs

| Nome | Descricao |
|---|---|
| `role_arn` | ARN da IAM Role criada |
| `role_name` | Nome da IAM Role criada |
| `role_unique_id` | Unique ID da IAM Role criada |
| `policy_arn` | ARN da IAM Policy criada |
| `policy_name` | Nome da IAM Policy criada |
| `policy_id` | ID da IAM Policy criada |
| `role_policy_attachment_id` | ID do anexo entre role e policy |

## Validacao

```bash
terraform fmt -check
terraform init -backend=false
terraform validate
```

Nao e necessario fornecer credenciais reais para `init -backend=false` e `validate`. Para `plan`/`apply`, forneca credenciais AWS validas e um valor para `trusted_principal_arns`.
