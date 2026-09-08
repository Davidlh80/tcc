# Blueprint Terraform — Amazon S3 Bucket

Este template cria um bucket S3 com configurações seguras por padrão:
- Bloqueio de acesso público (todas as opções ativas por padrão)
- Criptografia em repouso habilitada (SSE-S3 por padrão; opcional SSE-KMS)
- Versionamento (habilitado por padrão)
- Política que exige TLS (nega tráfego sem HTTPS)
- Regra de ciclo de vida para abortar uploads multipart incompletos
- Opcional: Server Access Logging para um bucket de logs dedicado

Arquivos:
- main.tf
- variables.tf
- outputs.tf
- versions.tf
- README.md

Pré-requisitos:
- Terraform >= 1.4.0
- Provider AWS >= 5.0
- Credenciais AWS configuradas no ambiente (para aplicar)

Como usar:
1) Ajuste as variáveis necessárias (ao menos bucket_name). Exemplo mínimo:
   -aws_region="us-east-1"
   -var 'bucket_name=meu-bucket-unico-global-123'

2) (Opcional) Habilite SSE-KMS informando uma chave KMS:
   -var 'kms_key_id=arn:aws:kms:us-east-1:111122223333:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

3) (Opcional) Habilite Server Access Logging para um bucket de logs existente:
   -var 'enable_access_logging=true'
   -var 'access_log_bucket_name=meu-bucket-de-logs'
   -var 'access_log_prefix=s3-access-logs/'

Comandos:
- terraform init -backend=false
- terraform validate
- terraform plan -var 'bucket_name=meu-bucket-unico-global-123'
- terraform apply -var 'bucket_name=meu-bucket-unico-global-123'

Variáveis principais:
- aws_region: Região AWS (padrão: us-east-1)
- bucket_name: Nome globalmente único do bucket (obrigatório)
- force_destroy: Permite destruir bucket não vazio (padrão: false)
- enable_versioning: Habilita versionamento (padrão: true)
- kms_key_id: ID/ARN KMS para SSE-KMS (padrão: null -> usa SSE-S3 AES256)
- bucket_key_enabled: S3 Bucket Keys com SSE-KMS (padrão: true)
- enable_access_logging: Habilita logs de acesso (padrão: false)
- access_log_bucket_name: Bucket de logs (necessário se enable_access_logging = true)
- access_log_prefix: Prefixo dos logs (padrão: s3-access-logs/)
- abort_incomplete_multipart_upload_days: Dias para abortar uploads incompletos (padrão: 7)
- block_public_acls / block_public_policy / ignore_public_acls / restrict_public_buckets: Controles de acesso público (padrão: true)
- object_ownership: BucketOwnerEnforced (padrão) | BucketOwnerPreferred | ObjectWriter
- tags: Tags adicionais (mapa)

Outputs:
- bucket_name, bucket_arn, bucket_id
- bucket_domain_name, bucket_regional_domain_name
- versioning_enabled
- encryption_algorithm
- access_logging_enabled

Notas:
- O nome do bucket deve ser único globalmente.
- Para Access Logging, o bucket de logs precisa existir e ter permissões para receber logs do S3.
- A política anexada nega qualquer solicitação sem HTTPS (aws:SecureTransport = false).
- Por padrão, criptografia SSE-S3 (AES256) é aplicada; forneça kms_key_id para usar SSE-KMS.
