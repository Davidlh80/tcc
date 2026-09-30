# IAM Role com IAM Policy anexada

Blueprint Terraform para provisionar uma IAM Role na AWS com uma IAM Policy dedicada anexada a ela via `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela e criada e imediatamente vinculada a role, que por sua vez so pode ser assumida pelo principal de confianca configurado.

## Decisoes de seguranca

- **Sem wildcards**: `allowed_actions`, `resource_arns` e `trusted_principal_identifiers` rejeitam o valor `"*"` via `validation` blocks, forcando escopo explicito de acoes, recursos e principais.
- **Least privilege por padrao**: o exemplo padrao de `allowed_actions` cobre apenas leitura de objetos S3 (`s3:GetObject`, `s3:ListBucket`); ajuste conforme a necessidade real do workload.
- **Trust policy explicita**: o assume role policy usa `aws_iam_policy_document` com `type`/`identifiers` configuraveis, evitando trust policies abertas (`Principal: "*"`).
- **Suporte a External ID**: para cenarios cross-account, defina `external_id` para mitigar o problema do "confused deputy".
- **Permissions boundary opcional**: `permissions_boundary_arn` permite aplicar um teto de permissoes adicional na role.
- **Sessao limitada**: `max_session_duration` restringe o tempo maximo de uma sessao assumida (padrao de 1 hora, minimo permitido pela AWS).
- **Sem credenciais reais**: o modulo nao depende de valores sensiveis fixos; tudo o que e configuravel e exposto via variaveis.

## Uso

```hcl
module "iam_role" {
  source = "./"

  role_name   = "app-readonly-s3-role"
  policy_name = "app-readonly-s3-policy"

  trusted_principal_type        = "Service"
  trusted_principal_identifiers = ["ec2.amazonaws.com"]

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  resource_arns = [
    "arn:aws:s3:::exemplo-bucket",
    "arn:aws:s3:::exemplo-bucket/*",
  ]

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

## Requisitos

| Nome | Versao |
|---|---|
| terraform | >= 1.5.0 |
| aws | ~> 5.0 |

## Inputs

| Nome | Descricao | Tipo | Default | Obrigatorio |
|---|---|---|---|---|
| aws_region | Regiao AWS usada pelo provider | string | "us-east-1" | nao |
| role_name | Nome da IAM Role | string | "app-scoped-role" | nao |
| role_description | Descricao da IAM Role | string | ver variables.tf | nao |
| policy_name | Nome da IAM Policy | string | "app-scoped-policy" | nao |
| policy_description | Descricao da IAM Policy | string | ver variables.tf | nao |
| trusted_principal_type | Tipo do principal de confianca (Service ou AWS) | string | "Service" | nao |
| trusted_principal_identifiers | Identificadores do principal de confianca | list(string) | ["ec2.amazonaws.com"] | nao |
| external_id | External ID exigido no assume role | string | null | nao |
| max_session_duration | Duracao maxima da sessao (segundos) | number | 3600 | nao |
| permissions_boundary_arn | ARN da permissions boundary | string | null | nao |
| allowed_actions | Acoes IAM permitidas na policy | list(string) | ["s3:GetObject", "s3:ListBucket"] | nao |
| resource_arns | ARNs dos recursos alvo das acoes permitidas | list(string) | - | **sim** |
| tags | Tags aplicadas na role e na policy | map(string) | { ManagedBy = "terraform" } | nao |

## Outputs

| Nome | Descricao |
|---|---|
| role_name | Nome da IAM Role criada |
| role_arn | ARN da IAM Role criada |
| role_id | ID unico da IAM Role criada |
| policy_name | Nome da IAM Policy criada |
| policy_arn | ARN da IAM Policy criada |
| policy_attachment_id | ID do attachment entre policy e role |

## Validacao

```bash
terraform init -backend=false
terraform validate
```
