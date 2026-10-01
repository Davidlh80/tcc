# IAM Role com Policy Gerenciada Anexada

## Visao geral

Esta blueprint provisiona:

- Uma IAM Role (`aws_iam_role.this`) com trust policy configuravel via variaveis.
- Uma IAM Policy gerenciada (`aws_iam_policy.this`) com permissoes definidas pelo consumidor do modulo.
- Um attachment (`aws_iam_role_policy_attachment.this`) que vincula a policy a role, garantindo que a policy nunca fique sem um principal associado.

Nenhum valor sensivel ou credencial real e utilizado. Todos os parametros de dominio (identificadores de principal, ARNs de recursos, acoes permitidas) sao fornecidos via variaveis.

## Requisitos

- Terraform >= 1.5.0
- Provider `hashicorp/aws` ~> 5.0
- Credenciais AWS validas apenas para `terraform plan`/`apply` (nao necessarias para `terraform validate`)

## Uso basico

```
module "app_role" {
  source = "./"

  role_name   = "minha-app-role"
  policy_name = "minha-app-policy"

  trusted_principal_type        = "Service"
  trusted_principal_identifiers = ["ec2.amazonaws.com"]

  allowed_actions = [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
  ]

  allowed_resource_arns = [
    "arn:aws:logs:us-east-1:111122223333:log-group:/app/minha-app:*",
  ]

  tags = {
    Ambiente = "producao"
  }
}
```

## Confianca entre contas (cross-account)

Para permitir que outra conta AWS assuma a role, defina:

```
trusted_principal_type        = "AWS"
trusted_principal_identifiers = ["arn:aws:iam::999988887777:root"]
external_id                   = "um-valor-secreto-compartilhado"
require_mfa                   = true
```

## Inputs principais

| Nome | Descricao | Default |
|---|---|---|
| `aws_region` | Regiao AWS do provider | `us-east-1` |
| `role_name` | Nome da IAM Role | `app-execution-role` |
| `policy_name` | Nome da IAM Policy | `app-execution-policy` |
| `trusted_principal_type` | Tipo do principal (`Service` ou `AWS`) | `Service` |
| `trusted_principal_identifiers` | Identificadores do principal de confianca | obrigatorio |
| `external_id` | External ID para assume role entre contas | `null` |
| `require_mfa` | Exige MFA para assumir a role | `false` |
| `max_session_duration` | Duracao maxima da sessao (segundos) | `3600` |
| `permissions_boundary_arn` | ARN de permissions boundary | `null` |
| `allowed_actions` | Acoes permitidas na policy | acoes minimas de CloudWatch Logs |
| `allowed_resource_arns` | ARNs de recursos alvo das acoes permitidas | obrigatorio |
| `denied_actions` | Acoes explicitamente negadas | `[]` |
| `tags` | Tags adicionais | `{}` |

## Outputs

- `role_name`, `role_arn`, `role_id`
- `policy_name`, `policy_arn`
- `policy_attachment_id`

## Consideracoes de seguranca

- `allowed_resource_arns` e obrigatorio e nao possui default com wildcard, forcando o consumidor a delimitar recursos explicitamente.
- Evite usar `"*"` em `allowed_actions` ou `allowed_resource_arns`; prefira acoes e ARNs especificos por servico e recurso.
- `require_mfa` e `external_id` reduzem o risco de "confused deputy" em cenarios cross-account.
- `permissions_boundary_arn` permite aplicar um limite adicional de permissoes, recomendado em ambientes com controles centralizados de IAM.
- A policy criada nunca existe de forma solta: o `aws_iam_role_policy_attachment` garante que ela esteja sempre associada a uma role com principal definido.

## Validacao

```
terraform init -backend=false
terraform validate
```
