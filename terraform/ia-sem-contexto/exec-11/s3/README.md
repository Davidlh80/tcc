Resumo
Blueprint Terraform para provisionar um bucket Amazon S3 com configurações seguras por padrão: bloqueio de acesso público, criptografia no lado do servidor, versionamento opcional, política para negar tráfego sem TLS e suporte opcional a logging.

Recursos criados
- aws_s3_bucket
- aws_s3_bucket_ownership_controls (BucketOwnerEnforced)
- aws_s3_bucket_public_access_block
- aws_s3_bucket_versioning
- aws_s3_bucket_server_side_encryption_configuration
- aws_s3_bucket_policy (opcional, nega acesso sem TLS)
- aws_s3_bucket_logging (opcional)

Pré-requisitos
- Terraform >= 1.4
- Provider AWS ~> 5.x
- Permissões AWS adequadas para S3 e, se aplicável, para uso da KMS Key

Como usar (exemplo mínimo)
- Defina as variáveis necessárias, principalmente bucket_name.
- Execute:
  terraform init -backend=false
  terraform validate
  terraform plan -var 'bucket_name=meu-bucket-exemplo-123'
  terraform apply -var 'bucket_name=meu-bucket-exemplo-123'

Variáveis principais
- bucket_name (obrigatória): nome único globalmente.
- region: padrão us-east-1.
- versioning_enabled: habilita versionamento (padrão true).
- sse_algorithm: AES256 (padrão) ou aws:kms.
- kms_key_id: necessário se sse_algorithm=aws:kms.
- enable_bucket_key: habilita S3 Bucket Key quando usa KMS (padrão true).
- force_destroy: destrói mesmo com objetos (padrão false).
- deny_insecure_transport: cria política que nega acesso sem TLS (padrão true).
- enable_logging: habilita logging para outro bucket (padrão false).
- logging_target_bucket: bucket de logs (requerido se enable_logging=true).
- logging_target_prefix: prefixo para logs (padrão s3-access-logs/).
- tags: mapa de tags adicionais. As tags também são aplicadas via default_tags no provider com ManagedBy=Terraform.

Boas práticas embutidas
- Bloqueio completo de acesso público via Public Access Block.
- Propriedade do objeto forçada ao dono do bucket (BucketOwnerEnforced), removendo dependência de ACLs.
- Criptografia no lado do servidor habilitada por padrão (AES256 ou KMS).
- Política para negar tráfego não criptografado (sem TLS), quando habilitada.

Observações
- Se utilizar aws:kms, forneça kms_key_id (ARN, ID ou alias) com permissões para o bucket S3.
- Para habilitar logging, é necessário já existir um bucket de destino e permissões adequadas.
- Este template não configura backend remoto e não depende de credenciais reais para validação sintática (terraform validate).

Saída (outputs)
- bucket_name, bucket_id, bucket_arn, bucket_domain_name, bucket_regional_domain_name, versioning_status, encryption_algorithm
