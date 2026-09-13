# Blueprint Terraform — Bucket Amazon S3

## Descricao

Esta blueprint provisiona um bucket Amazon S3 com configuracoes seguras por padrao:

- Bloqueio total de acesso publico (`aws_s3_bucket_public_access_block`).
- Propriedade de objetos imposta pelo dono do bucket, com ACLs desabilitadas (`BucketOwnerEnforced`).
- Criptografia server-side habilitada (SSE-S3 por padrao, ou SSE-KMS se uma chave for informada).
- Versionamento de objetos habilitado por padrao.
- Regra de lifecycle opcional para abortar uploads multipart incompletos, evitando custos de armazenamento residual.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-unico-exemplo"
  aws_region  = "us-east-1"

  tags = {
    Environment = "dev"
    Owner       = "time-plataforma"
  }
}
```

## Requisitos

| Nome | Versao |
|------|--------|
| terraform | >= 1.5.0 |
| aws | ~> 5.0 |

## Variaveis principais

| Nome | Descricao | Tipo | Default |
|------|-----------|------|---------|
| `bucket_name` | Nome globalmente unico do bucket | `string` | (obrigatorio) |
| `aws_region` | Regiao AWS | `string` | `us-east-1` |
| `force_destroy` | Permite destruir bucket com objetos | `bool` | `false` |
| `enable_versioning` | Habilita versionamento | `bool` | `true` |
| `kms_key_arn` | ARN de chave KMS para SSE-KMS | `string` | `null` |
| `enable_lifecycle_rule` | Habilita regra de lifecycle | `bool` | `true` |
| `abort_incomplete_multipart_upload_days` | Dias para abortar multipart incompleto | `number` | `7` |
| `tags` | Tags adicionais | `map(string)` | `{}` |

## Outputs

| Nome | Descricao |
|------|-----------|
| `bucket_id` | Nome do bucket criado |
| `bucket_arn` | ARN do bucket criado |
| `bucket_domain_name` | Dominio do bucket |
| `bucket_regional_domain_name` | Dominio regional do bucket |
| `bucket_region` | Regiao do bucket |

## Validacao local

```
terraform init -backend=false
terraform validate
```

## Observacoes de seguranca

- O acesso publico esta bloqueado por padrao e nao e configuravel via variavel, para evitar exposicao acidental de dados.
- Nenhuma credencial ou valor sensivel esta fixado no codigo.
- Recomenda-se fornecer `kms_key_arn` em ambientes que exigem criptografia gerenciada por chave dedicada.
