# IAM

Cria uma role IAM, uma policy e anexa a policy na role. A trust policy permite o `sts:AssumeRole` apenas para o servico AWS informado em `trusted_service`.

Como estamos fazendo um template, as ações e os recursos da policy são definidos por variável, possibilitando modificabilidade e seguindo os princípios de least privilege.

## Variaveis

| Nome | Tipo | Padrao | Descricao |
| --- | --- | --- | --- |
| `policy_name` | string | - | Nome da policy |
| `role_name` | string | - | Nome da role |
| `environment` | string | - | dev, hml ou prd |
| `owner` | string | - | E-mail do responsavel pelo recurso |
| `trusted_service` | string | - | Servico AWS que pode assumir a role |
| `allowed_actions` | list(string) | - | Acoes liberadas pela policy |
| `allowed_resources` | list(string) | - | ARNs dos recursos em que as acoes valem |
| `region` | string | `us-east-1` | Regiao AWS |

## Outputs

`policy_name`, `policy_arn`, `policy_id`, `role_name` e `role_arn`.

## Uso

```hcl
policy_name       = "app-leitura-dev"
role_name         = "app-leitura-dev"
environment       = "dev"
owner             = "time-plataforma@empresa.com"
trusted_service   = "lambda.amazonaws.com"
allowed_actions   = ["s3:GetObject", "s3:ListBucket"]
allowed_resources = ["arn:aws:s3:::meu-bucket", "arn:aws:s3:::meu-bucket/*"]
```

```sh
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
```
