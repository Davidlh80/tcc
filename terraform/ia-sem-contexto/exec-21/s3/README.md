# Blueprint Terraform — Bucket S3

Provisiona um bucket Amazon S3 com configuracoes seguras por padrao:

- Bloqueio total de acesso publico (`aws_s3_bucket_public_access_block`).
- Criptografia em repouso habilitada (SSE-S3 por padrao, ou SSE-KMS se uma chave for informada).
- Versionamento configuravel via variavel.
- Propriedade de objetos forcada para o dono do bucket (`BucketOwnerEnforced`), eliminando o uso de ACLs.
- Tags aplicadas ao recurso.

## Uso

```
module "bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo"
  tags = {
    ambiente = "dev"
  }
}
```

## Variaveis

| Nome                 | Descricao                                                      | Tipo          | Padrao  |
|----------------------|------------------------------------------------------------------|---------------|---------|
| `bucket_name`        | Nome globalmente unico do bucket S3                              | `string`      | -       |
| `versioning_enabled` | Habilita versionamento de objetos                                | `bool`        | `true`  |
| `force_destroy`      | Permite destruir o bucket mesmo com objetos                      | `bool`        | `false` |
| `kms_key_arn`        | ARN de chave KMS para SSE-KMS; se nulo, usa AES256               | `string`      | `null`  |
| `tags`               | Tags adicionais aplicadas ao bucket                               | `map(string)` | `{}`    |
| `aws_region`         | Regiao AWS onde o bucket sera criado                              | `string`      | -       |

## Outputs

| Nome                          | Descricao                                 |
|-------------------------------|---------------------------------------------|
| `bucket_id`                   | Nome (ID) do bucket criado                  |
| `bucket_arn`                  | ARN do bucket criado                        |
| `bucket_regional_domain_name` | Dominio regional do bucket                  |
| `versioning_status`           | Status atual do versionamento do bucket     |

## Validacao

```
terraform init -backend=false
terraform validate
```

Nao e necessario backend remoto nem credenciais reais para validacao sintatica.
