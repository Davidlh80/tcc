Nome
- Blueprint Terraform para provisionar um bucket Amazon S3 com configurações seguras por padrão.

Recursos criados
- aws_s3_bucket: bucket S3
- aws_s3_bucket_public_access_block: bloqueio de acesso público
- aws_s3_bucket_ownership_controls: ownership de objetos (BucketOwnerEnforced por padrão)
- aws_s3_bucket_versioning: versionamento habilitado por padrão
- aws_s3_bucket_server_side_encryption_configuration: criptografia SSE-S3 (AES256) por padrão, com opção de SSE-KMS
- aws_s3_bucket_logging (opcional): server access logging
- aws_s3_bucket_policy: exige HTTPS (nega transporte inseguro)

Variáveis principais
- aws_region (string, default: us-east-1): região AWS.
- bucket_name (string, obrigatório): nome globalmente único do bucket.
- force_destroy (bool, default: false): força destruição mesmo com objetos.
- enable_versioning (bool, default: true): habilita versionamento.
- object_ownership (string, default: BucketOwnerEnforced): modo de ownership.
- block_public_acls (bool, default: true)
- ignore_public_acls (bool, default: true)
- block_public_policy (bool, default: true)
- restrict_public_buckets (bool, default: true)
- kms_key_arn (string, default: vazio): ARN da chave KMS para SSE-KMS. Se vazio, usa AES256.
- enable_bucket_key (bool, default: true): habilita S3 Bucket Keys quando usando KMS.
- logging_target_bucket (string, default: vazio): bucket de destino do server access logging.
- logging_prefix (string, default: s3-access-logs/): prefixo dos logs.
- tags (map(string), default: {}): tags adicionais.

Como usar
1) Ajuste as variáveis conforme necessário (por exemplo via arquivo terraform.tfvars):
aws_region = "us-east-1"
bucket_name = "meu-bucket-unico-123456"
enable_versioning = true
kms_key_arn = ""
logging_target_bucket = ""
tags = {
  "env" = "dev"
}

2) Comandos básicos:
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Observações
- O nome do bucket deve ser único globalmente na AWS.
- Por padrão, o acesso público é bloqueado e o transporte inseguro (HTTP) é negado via política.
- Se fornecer kms_key_arn, a criptografia usará SSE-KMS e S3 Bucket Keys podem ser habilitadas via enable_bucket_key.
- Para usar Server Access Logging, informe logging_target_bucket e, se necessário, ajuste permissões no bucket de logs.
