# Template S3

## Visão geral

Cria um bucket Amazon S3 com configurações básicas de segurança e governança:

- bloqueio total de acesso público (as 4 flags do Public Access Block habilitadas);
- criptografia server-side padrão com `AES256` (SSE-S3);
- versionamento configurável por variável (habilitado por padrão);
- tags padrão (`Project`, `Environment`, `ManagedBy`), que podem ser complementadas por `additional_tags`.

## Variáveis

| Nome | Tipo | Obrigatória | Descrição |
| --- | --- | --- | --- |
| `name` | `string` | Sim | Nome do bucket S3 |
| `environment` | `string` | Não (padrão: `"dev"`) | Ambiente de implantação (`dev`, `hml` ou `prd`) |
| `enable_versioning` | `bool` | Não (padrão: `true`) | Habilita o versionamento do bucket |
| `additional_tags` | `map(string)` | Não (padrão: `{}`) | Tags extras aplicadas a todos os recursos |
| `region` | `string` | Não (padrão: `"us-east-1"`) | Região AWS onde os recursos serão criados |

## Outputs

| Nome | Descrição |
| --- | --- |
| `bucket_name` | Nome do bucket S3 |
| `bucket_arn` | ARN do bucket S3 |
| `bucket_id` | ID do bucket |

## Exemplo de uso

Como módulo:

```hcl
module "s3" {
  source = "./terraform/manual/p14/s3"

  name              = "dev-tcc-s3-exemplo"
  environment       = "dev"
  enable_versioning = true
  additional_tags = {
    Owner = "devops"
  }
}
```

Direto na pasta do template:

```bash
terraform init
terraform validate
terraform plan -var="name=dev-tcc-s3-exemplo"
```
