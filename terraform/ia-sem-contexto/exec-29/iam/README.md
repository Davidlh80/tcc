# IAM Policy - Blueprint Terraform

Blueprint autonomo para provisionamento de uma IAM Policy na AWS, gerado sem vinculo a padroes organizacionais especificos.

## Recursos criados

- `aws_iam_policy.this`: IAM Policy com uma statement unica, construida a partir de `data.aws_iam_policy_document.this`.

## Decisoes de design

- Privilegio minimo por padrao: `actions` e `resources` possuem valores de exemplo restritos (leitura em um bucket S3 especifico), nunca `*`.
- Wildcards bloqueados: validacoes em `variables.tf` impedem `"*"` em `actions` e `resources`, forcando a definicao explicita de permissoes.
- Sem anexacao automatica: este blueprint cria apenas a policy (`aws_iam_policy`). O anexamento a roles, usuarios ou grupos fica fora do escopo e deve ser feito por outro modulo/recurso, para evitar acoplamento implicito de privilegios.
- Sem credenciais reais: o provider AWS usa apenas a variavel `region`, suficiente para `terraform init -backend=false` e `terraform validate`.

## Uso

```
terraform init -backend=false
terraform validate
```

Para customizar a policy, ajuste as variaveis `policy_name`, `policy_description`, `effect`, `actions`, `resources`, `path` e `tags` via `terraform.tfvars` ou `-var`.

## Variaveis principais

| Nome                | Descricao                                   | Default                              |
|---------------------|----------------------------------------------|---------------------------------------|
| `region`            | Regiao AWS do provider                        | `us-east-1`                          |
| `policy_name`       | Nome da IAM Policy                             | `example-least-privilege-policy`     |
| `policy_description`| Descricao da IAM Policy                        | `Managed by Terraform`               |
| `path`              | Path da policy no IAM                          | `/`                                   |
| `sid`               | Sid da statement                               | `PolicyStatement`                     |
| `effect`            | `Allow` ou `Deny`                              | `Allow`                               |
| `actions`           | Lista de acoes IAM (sem wildcard)              | `["s3:GetObject", "s3:ListBucket"]`  |
| `resources`         | Lista de ARNs (sem wildcard)                   | `["arn:aws:s3:::example-bucket/*"]`  |
| `tags`              | Tags da policy                                 | `{}`                                  |

## Outputs

| Nome                    | Descricao                          |
|-------------------------|--------------------------------------|
| `policy_arn`             | ARN da IAM Policy criada             |
| `policy_id`              | ID da IAM Policy criada              |
| `policy_name`            | Nome da IAM Policy criada            |
| `policy_document_json`   | Documento JSON gerado para a policy  |
