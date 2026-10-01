# IAM Role com IAM Policy Anexada

Blueprint Terraform que provisiona uma IAM Role e uma IAM Policy gerenciada anexada a ela. A policy nunca fica solta: ela e sempre criada em conjunto com o `aws_iam_role_policy_attachment`, garantindo que exista um principal (a role) associado a ela desde a primeira aplicacao.

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role) configuravel via variaveis.
- `aws_iam_policy.this` — policy gerenciada com acoes e recursos configuraveis.
- `aws_iam_role_policy_attachment.this` — anexa a policy criada a role criada.
- `data.aws_iam_policy_document.assume_role` — documento JSON da trust policy.
- `data.aws_iam_policy_document.permissions` — documento JSON das permissoes da policy.

## Pre-requisitos

- Terraform >= 1.5.0
- Provider `hashicorp/aws` ~> 5.0
- Credenciais AWS validas apenas para `terraform plan`/`apply` (nao sao necessarias para `terraform init -backend=false` ou `terraform validate`)

## Como usar

Exemplo de `terraform.tfvars`:

```
role_name   = "app-readonly-role"
policy_name = "app-readonly-policy"

trusted_principal_type         = "Service"
trusted_principal_identifiers  = ["ec2.amazonaws.com"]

policy_actions   = ["s3:GetObject", "s3:ListBucket"]
policy_resources = [
  "arn:aws:s3:::exemplo-bucket",
  "arn:aws:s3:::exemplo-bucket/*"
]

tags = {
  Ambiente = "dev"
  Owner    = "time-plataforma"
}
```

Para confianca entre contas (cross-account assume role), utilize:

```
trusted_principal_type        = "AWS"
trusted_principal_identifiers = ["arn:aws:iam::111122223333:root"]
external_id                   = "um-valor-secreto-unico"
```

## Inputs principais

| Nome | Descricao | Default |
|---|---|---|
| `role_name` | Nome da IAM Role | obrigatorio |
| `policy_name` | Nome da IAM Policy | obrigatorio |
| `trusted_principal_type` | Tipo do principal confiavel (`AWS`, `Service`, `Federated`, `CanonicalUser`) | `"Service"` |
| `trusted_principal_identifiers` | Identificadores do principal confiavel | `["ec2.amazonaws.com"]` |
| `external_id` | External ID exigido na trust policy | `""` |
| `policy_actions` | Acoes permitidas pela policy (sem wildcard `*`) | `["s3:GetObject", "s3:ListBucket"]` |
| `policy_resources` | ARNs dos recursos permitidos | obrigatorio |
| `max_session_duration` | Duracao maxima da sessao assumida (segundos) | `3600` |
| `permissions_boundary_arn` | ARN de permissions boundary opcional | `""` |
| `tags` | Tags aplicadas aos recursos | `{}` |

## Outputs principais

| Nome | Descricao |
|---|---|
| `role_arn` | ARN da IAM Role criada |
| `role_name` | Nome da IAM Role criada |
| `policy_arn` | ARN da IAM Policy criada |
| `policy_name` | Nome da IAM Policy criada |
| `role_policy_attachment_id` | ID do attachment entre policy e role |

## Consideracoes de seguranca

- O wildcard `*` e bloqueado em `policy_actions` por validacao nativa do Terraform, forçando a definicao explicita de acoes minimas necessarias.
- `policy_resources` e obrigatorio e nao possui default, evitando que recursos sensiveis sejam expostos por um valor generico acidental.
- A trust policy suporta `external_id` para mitigar o problema de confused deputy em cenarios de assume role entre contas.
- `permissions_boundary_arn` permite aplicar uma boundary adicional para limitar o escopo maximo de permissoes da role.
- Nenhum valor sensivel ou credencial real e fixado no codigo; todos os dados configuraveis sao expostos como variaveis.
- Nao ha backend remoto configurado, mantendo o modulo autocontido para validacao sintatica local.
