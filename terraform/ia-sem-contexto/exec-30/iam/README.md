# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Role com uma trust policy (assume role) configuravel e uma IAM Policy customizada anexada a ela via `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela e sempre criada e anexada a uma Role no mesmo apply.

## Recursos criados

- `aws_iam_role.this` — Role com trust policy definida por `trusted_principal_type` / `trusted_principal_identifiers`.
- `aws_iam_policy.this` — Policy customizada, construida a partir de `policy_statements`.
- `aws_iam_role_policy_attachment.this` — Anexa a policy customizada a Role.
- `aws_iam_role_policy_attachment.additional` — Anexa managed policies adicionais (opcional, via `additional_managed_policy_arns`).

## Decisoes de seguranca

- `policy_statements` nao possui valor default: e obrigatorio declarar explicitamente as actions e resources necessarios, evitando permissões implícitas.
- Validacao bloqueia statements que combinem `actions = ["*"]` com `resources = ["*"]` na mesma statement.
- `trusted_principal_identifiers` exige ao menos um principal — a Role nunca fica sem um trust definido.
- `external_id` permite exigir `sts:ExternalId` na assume role, recomendado para cenarios cross-account.
- `permissions_boundary_arn` (opcional) permite aplicar um limite adicional de permissoes.
- `force_detach_policies = true` por padrao, para evitar Roles orfãs com policies presas ao destruir.

## Uso

```hcl
module "iam_role" {
  source = "./"

  role_name   = "ci-deploy-role"
  policy_name = "ci-deploy-policy"

  trusted_principal_type         = "AWS"
  trusted_principal_identifiers  = ["arn:aws:iam::123456789012:root"]
  external_id                    = "troque-por-um-valor-unico-e-secreto"

  policy_statements = [
    {
      sid       = "ReadDeployArtifacts"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::meu-bucket-deploy",
        "arn:aws:s3:::meu-bucket-deploy/*"
      ]
    }
  ]

  tags = {
    Environment = "prod"
    Owner       = "plataforma"
  }
}
```

## Requisitos

| Nome | Versao |
|---|---|
| terraform | >= 1.9.0 |
| aws | ~> 5.0 |

## Inputs principais

| Nome | Descricao | Tipo | Default |
|---|---|---|---|
| aws_region | Regiao AWS do provider | string | "us-east-1" |
| role_name | Nome da IAM Role | string | "app-role" |
| policy_name | Nome da IAM Policy | string | "app-policy" |
| trusted_principal_type | Tipo do principal da trust policy | string | "Service" |
| trusted_principal_identifiers | Identificadores do principal confiavel | list(string) | ["ec2.amazonaws.com"] |
| external_id | External ID exigido na assume role | string | null |
| permissions_boundary_arn | ARN de permissions boundary | string | null |
| policy_statements | Statements da IAM Policy (obrigatorio) | list(object) | — |
| additional_managed_policy_arns | Managed policies extras a anexar | list(string) | [] |
| tags | Tags adicionais | map(string) | {} |

## Outputs principais

| Nome | Descricao |
|---|---|
| role_arn | ARN da IAM Role |
| role_name | Nome da IAM Role |
| policy_arn | ARN da IAM Policy |
| policy_name | Nome da IAM Policy |
| role_policy_attachment_id | ID do anexo policy-role |
| assume_role_policy_json | JSON da trust policy aplicada |

## Validacao local

```bash
terraform init -backend=false
terraform validate
terraform fmt -check
```

Nenhum backend remoto e nenhuma credencial real sao necessarios para `init` e `validate`.
