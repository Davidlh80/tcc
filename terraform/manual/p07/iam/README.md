# IAM

Cria uma policy IAM, uma role e anexa a policy na role. A trust policy libera o `sts:AssumeRole` apenas para o servico AWS informado em `trusted_service`.

## Variaveis

| Nome | Tipo | Padrao | Descricao |
| --- | --- | --- | --- |
| `policy_name` | string | - | Nome da policy |
| `role_name` | string | - | Nome da role |
| `environment` | string | - | dev, hml ou prd |
| `trusted_service` | string | `ec2.amazonaws.com` | Servico que assume a role |
| `allowed_actions` | list(string) | - | Acoes permitidas (sem `*`) |
| `allowed_resources` | list(string) | - | ARNs dos recursos (sem `*` sozinho) |
| `additional_tags` | map(string) | `{}` | Tags extras |
| `region` | string | `us-east-1` | Regiao AWS |

## Outputs

`policy_name`, `policy_arn`, `policy_id`, `role_name` e `role_arn`.

## Uso

```hcl
policy_name       = "app-leitura-dev"
role_name         = "app-leitura-dev"
environment       = "dev"
trusted_service   = "lambda.amazonaws.com"
allowed_actions   = ["s3:GetObject", "s3:ListBucket"]
allowed_resources = ["arn:aws:s3:::meu-bucket", "arn:aws:s3:::meu-bucket/*"]
```

```sh
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
```
