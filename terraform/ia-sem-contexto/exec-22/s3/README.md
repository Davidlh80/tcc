# Blueprint Terraform - Bucket S3 (AWS)

Blueprint autonomo, sem vinculo com padroes organizacionais especificos, para provisionar um bucket Amazon S3 seguro por padrao.

## Recursos criados

- `aws_s3_bucket` - bucket S3 principal
- `aws_s3_bucket_ownership_controls` - forca `BucketOwnerEnforced`, desabilitando ACLs
- `aws_s3_bucket_public_access_block` - bloqueia qualquer acesso publico (ACLs e policies)
- `aws_s3_bucket_versioning` - versionamento de objetos
- `aws_s3_bucket_server_side_encryption_configuration` - criptografia SSE-S3 (AES256) ou SSE-KMS
- `aws_s3_bucket_logging` (opcional) - logs de acesso para outro bucket
- `aws_s3_bucket_lifecycle_configuration` (opcional) - regras de expiracao de objetos e versoes antigas

## Decisoes de seguranca padrao

- Acesso publico totalmente bloqueado (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets` = `true`), sem opcao de desativar via variavel.
- ACLs desabilitadas via `BucketOwnerEnforced`, seguindo a recomendacao atual da AWS.
- Criptografia em repouso habilitada por padrao (AES256); pode ser elevada para SSE-KMS informando `kms_key_arn`.
- Versionamento habilitado por padrao.
- `force_destroy` desabilitado por padrao para evitar exclusao acidental de dados.

## Uso

```
module "bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-unico"

  tags = {
    Environment = "dev"
    Owner       = "time-plataforma"
  }
}
```

## Inputs

| Nome | Descricao | Tipo | Default | Obrigatorio |
|---|---|---|---|---|
| aws_region | Regiao AWS | string | "us-east-1" | nao |
| bucket_name | Nome globalmente unico do bucket | string | - | sim |
| force_destroy | Permite exclusao do bucket com objetos | bool | false | nao |
| versioning_enabled | Habilita versionamento | bool | true | nao |
| kms_key_arn | ARN de chave KMS para SSE-KMS | string | "" | nao |
| logging_target_bucket | Bucket de destino dos logs de acesso | string | "" | nao |
| logging_target_prefix | Prefixo dos logs de acesso | string | "log/" | nao |
| lifecycle_rules | Regras de ciclo de vida do bucket | list(object) | [] | nao |
| tags | Tags aplicadas ao bucket | map(string) | {} | nao |

## Outputs

| Nome | Descricao |
|---|---|
| bucket_id | Nome (id) do bucket |
| bucket_arn | ARN do bucket |
| bucket_domain_name | Dominio do bucket |
| bucket_regional_domain_name | Dominio regional do bucket |
| versioning_status | Status atual do versionamento |

## Validacao

```
terraform init -backend=false
terraform validate
```

Nenhuma credencial real e necessaria para `init` e `validate`. Nenhum backend remoto e configurado.
