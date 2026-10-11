# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Policy com permissoes escopadas, anexada a uma unica IAM Role, com trust policy (assume role policy) restrita a um principal configuravel.

## Recursos criados

- `aws_iam_role.this` — IAM Role com trust policy restrita.
- `aws_iam_policy.this` — IAM Policy com actions e resources configuraveis.
- `aws_iam_role_policy_attachment.this` — Vinculo entre a policy e a role (a policy nunca fica solta, sem principal associado).

## Decisoes de seguranca

- A trust policy (`data.aws_iam_policy_document.assume_role`) nunca permite `"*"` como principal: a variavel `principal_identifiers` rejeita esse valor via `validation`.
- Suporte opcional a `sts:ExternalId` para cenarios de acesso cross-account de terceiros (`var.external_id`).
- A policy de permissoes (`data.aws_iam_policy_document.this`) exige `policy_actions` e `policy_resources` explicitos; ambos rejeitam o wildcard amplo `"*"` via `validation`, evitando permissoes administrativas implicitas.
- Suporte opcional a `permissions_boundary_arn` para limitar o escopo maximo de permissoes da role.
- Nenhum valor sensivel ou credencial real e utilizado; ARNs de principal e de recursos devem ser fornecidos pelo consumidor do modulo.

## Uso

```
module "iam_role_with_policy" {
  source = "./"

  role_name   = "app-backend-role"
  policy_name = "app-backend-policy"

  principal_type         = "AWS"
  principal_identifiers  = ["arn:aws:iam::111122223333:role/trusted-ci-role"]

  policy_actions   = ["s3:GetObject", "s3:ListBucket"]
  policy_resources = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  tags = {
    Environment = "production"
    Owner        = "platform-team"
  }
}
```

## Variaveis principais

| Nome | Descricao | Obrigatoria |
|---|---|---|
| `principal_identifiers` | ARNs ou nomes de servico autorizados a assumir a role | Sim |
| `policy_resources` | ARNs dos recursos cobertos pela policy | Sim |
| `role_name`, `policy_name` | Nomes dos recursos | Nao (possuem default) |
| `policy_actions` | Actions permitidas pela policy | Nao (default minimo de exemplo) |
| `external_id`, `permissions_boundary_arn` | Controles de seguranca adicionais | Nao |

## Outputs

- `role_arn`, `role_name`, `role_id`
- `policy_arn`, `policy_name`, `policy_id`
- `assume_role_policy_json`

## Validacao

```
terraform init -backend=false
terraform validate
```
