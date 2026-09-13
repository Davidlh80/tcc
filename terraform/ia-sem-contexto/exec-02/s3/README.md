# S3 Bucket - Blueprint Terraform

Blueprint Terraform para provisionamento de um bucket Amazon S3 seguro por padrao, sem dependencia de contexto organizacional especifico.

## Recursos criados

- `aws_s3_bucket`: bucket S3 principal.
- `aws_s3_bucket_ownership_controls`: forca `BucketOwnerEnforced`, eliminando o uso de ACLs.
- `aws_s3_bucket_versioning`: versionamento configuravel (habilitado por padrao).
- `aws_s3_bucket_server_side_encryption_configuration`: criptografia SSE-S3 (AES256) por padrao, ou SSE-KMS se uma chave for informada.
- `aws_s3_bucket_public_access_block`: bloqueia todo acesso publico (ACLs e politicas).
- `aws_s3_bucket_policy`: nega explicitamente qualquer acesso que nao utilize TLS (`aws:SecureTransport`).

## Postura de seguranca

- Acesso publico bloqueado incondicionalmente (nao configuravel via variavel, por padrao seguro).
- Object Ownership forcado para o proprietario do bucket, eliminando ACLs.
- Criptografia em repouso habilitada por padrao (AES256), com suporte opcional a SSE-KMS.
- Trafego HTTP (sem TLS) bloqueado por politica de bucket.
- Nenhuma credencial ou valor sensivel fixo no codigo.

## Uso

```
module "s3_bucket" {
  source = "./"

  bucket_name = "meu-bucket-unico-exemplo"
  aws_region  = "us-east-1"
  environment = "dev"

  tags = {
    Owner = "time-plataforma"
  }
}
```

## Variaveis principais

| Nome | Descricao | Padrao |
|---|---|---|
| `bucket_name` | Nome global do bucket (obrigatorio) | - |
| `aws_region` | Regiao AWS | `us-east-1` |
| `environment` | Ambiente para tagging | `dev` |
| `force_destroy` | Permite destruir bucket com objetos | `false` |
| `enable_versioning` | Habilita versionamento | `true` |
| `kms_key_arn` | ARN de chave KMS para SSE-KMS | `null` |
| `tags` | Tags adicionais | `{}` |

## Outputs

- `bucket_id`
- `bucket_arn`
- `bucket_domain_name`
- `bucket_regional_domain_name`
- `aws_region`

## Validacao

```
terraform init -backend=false
terraform validate
```

Nao requer credenciais reais da AWS para validacao sintatica. Nao utiliza backend remoto.
