Nome
Blueprint Terraform para criar um bucket Amazon S3 com configurações seguras por padrão.

Recursos provisionados
- aws_s3_bucket
- aws_s3_bucket_ownership_controls (BucketOwnerEnforced)
- aws_s3_bucket_public_access_block (bloqueio total de acesso público)
- aws_s3_bucket_versioning (versionamento opcional, habilitado por padrão)
- aws_s3_bucket_server_side_encryption_configuration (SSE-S3 por padrão, opcional KMS)
- aws_s3_bucket_lifecycle_configuration (aborta uploads multipart incompletos; expiração opcional)
- aws_s3_bucket_policy (nega tráfego sem TLS)

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS válidas no ambiente somente para aplicar (não necessárias para terraform validate)

Variáveis principais
- region: Regiao AWS (default: us-east-1)
- bucket_name: Nome globalmente único do bucket (obrigatório)
- versioning_enabled: true/false (default: true)
- force_destroy: true/false (default: false)
- sse_algorithm: AES256 ou aws:kms (default: AES256)
- kms_key_arn: ARN da CMK KMS quando usar aws:kms (opcional; se ausente, usa aws/s3)
- bucket_key_enabled: true/false (default: true; apenas com aws:kms)
- lifecycle_abort_incomplete_multipart_upload_days: dias para abortar uploads multipart (default: 7)
- lifecycle_expiration_days: dias para expiração de objetos (default: null = desabilitado)
- enable_bucket_policy: cria policy para negar tráfego sem TLS (default: true)
- tags: mapa de tags adicionais

Como usar
1) Ajuste as variáveis conforme necessário (por exemplo via terraform.tfvars):
bucket_name = "meu-bucket-exemplo-123"
region      = "us-east-1"
versioning_enabled = true
force_destroy      = false
sse_algorithm      = "AES256"
tags = {
  project = "demo"
  env     = "dev"
}

2) Inicialização e validação local:
terraform init -backend=false
terraform validate
terraform plan

3) Aplicação:
terraform apply

Saída (outputs) relevantes
- bucket_id, bucket_arn, bucket_name
- bucket_domain_name, bucket_regional_domain_name, bucket_hosted_zone_id
- bucket_versioning_status
- encryption_algorithm, kms_key_arn
- bucket_policy_id
- region

Notas
- Segurança por padrão: bloqueio de acesso público, criptografia em repouso, e policy que nega tráfego sem TLS.
- Para usar KMS (aws:kms), opcionalmente informe kms_key_arn; se não informado, a chave gerenciada aws/s3 será utilizada.
