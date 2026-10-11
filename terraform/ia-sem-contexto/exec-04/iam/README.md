# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Policy anexada a uma IAM Role na AWS, com trust policy restrita a principals configuraveis e permissoes limitadas a acoes e recursos explicitamente definidos.

## Recursos criados

- `aws_iam_role.this`: IAM Role com trust policy (assume role policy) restrita aos ARNs informados em `trusted_principal_arns`.
- `aws_iam_policy.this`: IAM Policy com acoes limitadas a `allowed_actions` sobre os recursos definidos em `allowed_resources`.
- `aws_iam_role_policy_attachment.this`: anexa a policy criada a role criada, garantindo que a policy nunca fique sem um principal associado.

## Caracteristicas de seguranca

- A trust policy nao aceita `"*"` como principal; `trusted_principal_arns` exige ao menos um ARN valido de conta, role ou usuario.
- `allowed_actions` nao aceita o wildcard total `"*"` nem `"iam:*"`, evitando permissoes administrativas amplas.
- Nao ha credenciais, segredos ou identificadores de conta fixos no codigo; tudo e parametrizado via variaveis.
- Tags sao aplicadas tanto a role quanto a policy, quando fornecidas.

## Uso

```hcl
module "iam_role_with_policy" {
  source = "./"

  role_name   = "ci-deploy-role"
  policy_name = "ci-deploy-policy"

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/ci-pipeline-role",
  ]

  allowed_actions = [
    "s3:GetObject",
    "s3:PutObject",
  ]

  allowed_resources = [
    "arn:aws:s3:::meu-bucket-exemplo/*",
  ]

  tags = {
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}
```

## Variaveis principais

| Nome                      | Descricao                                                        | Obrigatoria |
|---------------------------|-------------------------------------------------------------------|-------------|
| `trusted_principal_arns`  | ARNs autorizados a assumir a role (sem `"*"`).                   | Sim         |
| `allowed_actions`         | Acoes IAM permitidas na policy (sem `"*"` ou `"iam:*"`).          | Sim         |
| `allowed_resources`       | Recursos sobre os quais as acoes se aplicam.                      | Sim         |
| `role_name`               | Nome da IAM Role.                                                  | Nao         |
| `policy_name`             | Nome da IAM Policy.                                                | Nao         |
| `max_session_duration`    | Duracao maxima de sessao assumida (3600 a 43200 segundos).         | Nao         |
| `tags`                    | Tags aplicadas aos recursos.                                       | Nao         |

## Outputs

- `role_name`, `role_arn`, `role_id`: identificadores da role criada.
- `policy_name`, `policy_arn`, `policy_id`: identificadores da policy criada.
- `assume_role_policy_json`: documento JSON da trust policy aplicada.

## Validacao

```bash
terraform init -backend=false
terraform validate
```

Nenhum backend remoto e nenhuma credencial real sao necessarios para `init` e `validate`. Para `plan`/`apply`, forneca valores concretos para `trusted_principal_arns`, `allowed_actions` e `allowed_resources` conforme o caso de uso real.
