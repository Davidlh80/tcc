# IAM Policy — Terraform Blueprint

Blueprint Terraform para provisionar uma IAM Policy na AWS, com foco em privilégio mínimo e statements configuráveis via variáveis.

## Recursos criados

- `aws_iam_policy.this` — a política IAM.
- `data.aws_iam_policy_document.this` — documento de política renderizado dinamicamente a partir de `var.statements`.

## Uso

```hcl
module "iam_policy" {
  source = "./"

  policy_name        = "app-s3-readonly"
  policy_description = "Read-only access to the app data bucket"

  statements = [
    {
      sid       = "AllowReadAppBucket"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::app-data-bucket",
        "arn:aws:s3:::app-data-bucket/*"
      ]
    }
  ]

  tags = {
    Environment = "production"
    Owner       = "platform-team"
  }
}
```

## Inputs

| Nome                | Tipo           | Padrão                                   | Descrição                                                        |
|---------------------|----------------|-------------------------------------------|-------------------------------------------------------------------|
| aws_region           | string         | `"us-east-1"`                             | Região AWS usada pelo provider.                                   |
| policy_name          | string         | *(obrigatório)*                           | Nome único da IAM Policy na conta.                                 |
| policy_description   | string         | `"Managed by Terraform."`                 | Descrição da política.                                             |
| policy_path          | string         | `"/"`                                      | Path da IAM Policy.                                                |
| statements           | list(object)   | statement de exemplo somente leitura S3   | Lista de statements (sid, effect, actions, resources).             |
| tags                 | map(string)    | `{}`                                       | Tags aplicadas à política.                                         |

## Outputs

| Nome                  | Descrição                                  |
|-----------------------|----------------------------------------------|
| policy_arn            | ARN da IAM Policy criada.                     |
| policy_id             | ID da IAM Policy criada.                      |
| policy_name           | Nome da IAM Policy criada.                    |
| policy_document_json  | JSON renderizado do documento de política.    |

## Boas práticas de segurança

- Prefira `actions` e `resources` explícitos ao invés de `"*"`, seguindo o princípio de menor privilégio.
- Revise cada statement quanto ao efeito (`Allow`/`Deny`) e ao escopo de recursos antes de aplicar em produção.
- Use `tags` para rastreabilidade e governança (ex.: `Owner`, `Environment`, `CostCenter`).
- Esta política não é anexada automaticamente a nenhuma role, user ou group — anexe-a explicitamente conforme o caso de uso, usando `aws_iam_role_policy_attachment`, `aws_iam_user_policy_attachment` ou `aws_iam_group_policy_attachment`.

## Validação

```bash
terraform init -backend=false
terraform validate
```
