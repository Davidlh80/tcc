# Blueprint Terraform — Amazon S3 Bucket

Este template provisiona um bucket Amazon S3 com configurações seguras por padrão:
- Bloqueio total de acesso público (Public Access Block).
- Propriedade de objetos forçada ao dono do bucket (BucketOwnerEnforced).
- Criptografia em repouso por padrão (AES256 por default, opcional KMS).
- Versionamento habilitado por padrão.
- Política que nega qualquer acesso sem TLS (aws:SecureTransport = false).

Arquivos:
- main.tf: recursos e políticas do S3.
- variables.tf: variáveis configuráveis e validações.
- outputs.tf: saídas úteis do bucket.
- versions.tf: versão do Terraform e providers.
- README.md: instruções de uso.

Pré-requisitos:
- Terraform instalado.
- Credenciais AWS válidas exportadas no ambiente (ex.: AWS_PROFILE, AWS_ACCESS_KEY_ID, etc.) ou configuradas no AWS CLI.
- O nome do bucket deve ser globalmente único.

Como usar:
1) Ajuste as variáveis via terraform.tfvars (exemplo abaixo) ou via -var.
2) Execute:
   - terraform init -backend=false
   - terraform validate
   - terraform plan
   - terraform apply

Exemplo de terraform.tfvars:
aws_region           = "us-east-1"
bucket_name          = "meu-bucket-unico-123456"
environment          = "dev"
versioning_enabled   = true
force_destroy        = false
sse_algorithm        = "AES256" # ou "aws:kms"
# sse_kms_key_arn    = "arn:aws:kms:us-east-1:111122223333:key/abcd-efgh-ijkl" # opcional, se usar aws:kms
logging_enabled      = false
# logging_target_bucket = "meu-bucket-de-logs-123456" # obrigatório se logging_enabled = true
logging_target_prefix = "s3-access-logs/"
tags = {
  Project = "demo"
  Owner   = "meu-time"
}

Notas:
- Se optar por aws:kms em sse_algorithm e não informar sse_kms_key_arn, será usada a AWS Managed KMS Key para S3.
- Para habilitar access logging, forneça um bucket de logs existente em logging_target_bucket. Recomenda-se que seja um bucket dedicado para logs, distinto do bucket principal.
- force_destroy permanece false por segurança, evitando exclusão acidental de buckets com objetos.

Saídas:
- bucket_name: nome do bucket.
- bucket_arn: ARN do bucket.
- bucket_regional_domain_name: domínio regional do bucket.
- bucket_hosted_zone_id: útil para Route53 alias.
- bucket_policy_id: ID da política de negação de acesso sem TLS.

Limitações:
- Não há backend remoto configurado (somente local), adequado para validação e uso simples.
