# Terraform S3 Bucket

Blueprint Terraform para provisionar um bucket Amazon S3 com configuracoes seguras por padrao:
- Bloqueio de acesso publico (Public Access Block)
- Ownership Controls (BucketOwnerEnforced) para desativar ACLs
- Criptografia server-side (SSE-S3 por padrao ou SSE-KMS opcional)
- Versionamento habilitado por padrao
- Politica que exige transporte seguro (TLS)
- Regra de lifecycle para abortar uploads multiparte incompletos

## Uso rapido

1) Ajuste as variaveis (minimo: bucket_name). Exemplo de arquivo terraform.tfvars:
bucket_name = "meu-bucket-unico-global-123"
aws_region  = "us-east-1"

2) Inicialize e valide:
terraform init -backend=false
terraform validate

3) Planeje e aplique:
terraform plan
terraform apply

Para habilitar SSE-KMS:
sse_kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

Para habilitar Server Access Logging (requer um bucket de logs existente no mesmo account/region):
logging_enabled       = true
logging_target_bucket = "meu-bucket-de-logs"
logging_target_prefix = "s3-access-logs/"

## Variaveis principais

- bucket_name (obrigatorio): nome unico global do bucket.
- aws_region (opcional): regiao AWS. Padrao: us-east-1.
- bucket_versioning_enabled: habilita versionamento. Padrao: true.
- force_destroy: permite destruir com objetos. Padrao: false.
- sse_kms_key_arn: ARN da CMK para SSE-KMS. Se nulo, usa AES256.
- sse_bucket_key_enabled: habilita S3 Bucket Keys. Padrao: true.
- abort_incomplete_multipart_upload_days: dias para abortar uploads incompletos. Padrao: 7.
- logging_enabled: habilita server access logging. Padrao: false.
- logging_target_bucket / logging_target_prefix: destino e prefixo de logs.
- block_public_acls, block_public_policy, ignore_public_acls, restrict_public_buckets: controles de acesso publico. Padrao: true.
- tags: mapa de tags adicionais.

## Outputs

- bucket_id, bucket_arn, bucket_domain_name, bucket_regional_domain_name
- versioning_status
- encryption_algorithm, kms_key_arn
- logging_enabled
- aws_region

Notas:
- Este template evita backends remotos e valores sensiveis hardcoded.
- Compatibilidade: terraform fmt, terraform init -backend=false, terraform validate.
- Certifique-se de fornecer um nome de bucket unico global em bucket_name.
