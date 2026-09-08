Blueprint Terraform: Bucket Amazon S3 (AWS)

Visão geral
- Cria um bucket S3 com:
  - Criptografia em repouso por padrão (SSE-KMS com chave gerenciada AWS S3, a menos que informado um KMS Key ARN).
  - Versionamento habilitado por padrão.
  - Bloqueio de acesso público (todos os controles em true).
  - OwnershipControls com BucketOwnerEnforced (ACLs desabilitadas).
  - Política que nega acessos sem TLS (aws:SecureTransport=false).
  - Lifecycle para abortar uploads multipart incompletos após N dias (padrão 7).
  - Opção de logging de acesso (desabilitado por padrão).

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS configuradas no ambiente (por exemplo, variáveis de ambiente ou perfil do AWS CLI).

Como usar (exemplo rápido)
1) Ajuste as variáveis conforme necessário (veja Inputs).
2) Execute:
- terraform init -backend=false
- terraform plan -var 'bucket_name=seu-bucket-unico-123' -var 'region=us-east-1'
- terraform apply -var 'bucket_name=seu-bucket-unico-123' -var 'region=us-east-1'

Inputs principais
- bucket_name (obrigatório): nome globalmente único do bucket (3-63 chars; minúsculas, números e hífens).
- region: região AWS do provider. Padrão: us-east-1.
- tags: mapa de tags adicionais. A tag ManagedBy=Terraform é aplicada automaticamente.
- force_destroy: se true, permite destruir bucket não vazio. Padrão: false.
- versioning_enabled: habilita versionamento. Padrão: true.
- sse_algorithm: AES256 ou aws:kms. Padrão: aws:kms.
- kms_key_arn: ARN da KMS Key. Se omitido com aws:kms, usa chave gerenciada AWS S3 (alias/aws/s3).
- bucket_key_enabled: habilita S3 Bucket Keys (SSE-KMS). Padrão: true.
- block_public_acls, block_public_policy, ignore_public_acls, restrict_public_buckets: controles de acesso público. Todos padrão: true.
- enable_access_logging: habilita Server Access Logging. Padrão: false.
- logging_target_bucket: bucket de destino dos logs (pré-existente e diferente deste bucket). Obrigatório se enable_access_logging=true.
- logging_target_prefix: prefixo dos objetos de log. Padrão: logs/
- lifecycle_abort_incomplete_multipart_upload_days: aborta uploads multipart após N dias. Padrão: 7.
- lifecycle_expiration_days: remove objetos após N dias. Padrão: null (desabilitado).
- noncurrent_version_expiration_days: remove versões não atuais após N dias. Padrão: null (desabilitado).

Outputs
- bucket_name: nome do bucket.
- bucket_arn: ARN do bucket.
- bucket_domain_name: domain name global.
- bucket_regional_domain_name: domain name regional.
- region: região usada.
- versioning_enabled: se o versionamento está habilitado.
- sse_algorithm: algoritmo de criptografia do bucket.
- kms_key_arn: ARN da KMS Key efetiva (ou null se não definida).

Boas práticas e notas
- O nome do bucket deve ser único globalmente. Ajuste bucket_name antes de aplicar.
- Com BucketOwnerEnforced, ACLs são desabilitadas. Prefira políticas e IAM.
- Os controles de acesso público estão todos ativados por padrão; modifique-os apenas se entender os riscos.
- A política do bucket nega acessos sem TLS (HTTPS é obrigatório).
- Para logging de acesso, o bucket de destino deve existir previamente e permitir gravação a partir deste bucket.

Comandos úteis
- terraform fmt
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply
- terraform destroy

Observação
- Este template evita backend remoto para simplificar a validação em pipelines.
