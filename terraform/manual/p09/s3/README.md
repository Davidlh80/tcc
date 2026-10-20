# S3

Cria um bucket S3 privado, com acesso público bloqueado, criptografia com chave KMS própria e versionamento configurável.

A chave KMS é criada junto com o bucket e tem rotação automática anual habilitada. O versionamento vem ligado por padrão para proteger contra exclusão ou sobrescrita acidental de arquivos apesar de não ser a opção mais barata.

## Variaveis

| Nome | Tipo | Padrao | Descricao |
| --- | --- | --- | --- |
| `name` | string | - | Nome do bucket (unico globalmente) |
| `environment` | string | - | dev, hml ou prd |
| `owner` | string | - | E-mail do responsavel pelo recurso |
| `versioning_enabled` | bool | `true` | Liga ou suspende o versionamento |
| `region` | string | `us-east-1` | Regiao AWS |

## Outputs

`bucket_name`, `bucket_arn` e `bucket_id`.

## Uso

```hcl
name               = "empresa-app-arquivos-dev"
environment        = "dev"
owner              = "time-plataforma@empresa.com"
versioning_enabled = true
```

```sh
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
```
