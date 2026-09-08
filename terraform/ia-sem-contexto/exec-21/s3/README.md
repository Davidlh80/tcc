Nome
- Blueprint Terraform para criar um bucket Amazon S3 seguro por padrao.

Recursos criados
- aws_s3_bucket: bucket S3 com force_destroy configuravel.
- aws_s3_bucket_ownership_controls: BucketOwnerEnforced (desativa ACLs).
- aws_s3_bucket_public_access_block: bloqueia acesso publico por padrao.
- aws_s3_bucket_versioning: versionamento habilitado por padrao.
- aws_s3_bucket_server_side_encryption_configuration: criptografia SSE-S3 (AES256) por padrao, opcional KMS.
- aws_s3_bucket_policy (opcional): nega trafego sem TLS (aws:SecureTransport=false).

Pre-requisitos
- Terraform >= 1.4.0
- Provider AWS >= 5.0
- Credenciais AWS exportadas no ambiente (para aplicar), por exemplo via AWS_PROFILE ou variaveis de ambiente.

Como usar
1) Ajuste variaveis conforme necessario (veja Variaveis):
- bucket_name (obrigatorio; deve ser globalmente unico).
- opcionalmente ajuste aws_region, tags, e demais parametros.

2) Comandos basicos:
- terraform init -backend=false
- terraform validate
- terraform plan -var 'bucket_name=meu-bucket-unico-123'
- terraform apply -var 'bucket_name=meu-bucket-unico-123'

Variaveis principais
- aws_region (string, default: us-east-1): regiao AWS.
- bucket_name (string, obrigatoria): nome globalmente unico do bucket.
- force_destroy (bool, default: false): remove objetos ao destruir o bucket.
- enable_versioning (bool, default: true): ativa versionamento.
- sse_algorithm (string, default: AES256): AES256 ou aws:kms.
- sse_kms_key_id (string, default: null): ARN/alias da KMS Key quando usar aws:kms.
- enable_bucket_key (bool, default: true): ativa S3 Bucket Keys com KMS.
- attach_deny_insecure_transport (bool, default: true): aplica politica que exige TLS.
- block_public_acls, ignore_public_acls, block_public_policy, restrict_public_buckets (bools, default: true): controles de acesso publico.
- default_tags (map(string), default: {}): tags padrao via provider.
- bucket_tags (map(string), default: {}): tags especificas do bucket.

Decisoes de seguranca padrao
- Bloqueio de acesso publico ativado.
- Criptografia no servidor habilitada por padrao (AES256).
- Politica que exige conexao segura (TLS) ativada por padrao.
- Ownership Controls com BucketOwnerEnforced (ACLs desativadas).

Observacoes
- Para usar KMS, defina sse_algorithm="aws:kms" e, opcionalmente, sse_kms_key_id com uma chave valida (pode ser um alias: alias/minha-chave ou ARN).
- O nome do bucket deve ser unico globalmente na AWS e obedecer as regras de nomeacao do S3.
- Nao ha backend remoto configurado neste template.

Outputs
- bucket_id: nome/ID do bucket.
- bucket_arn: ARN do bucket.
- bucket_domain_name: endpoint do bucket.
- bucket_regional_domain_name: endpoint regional do bucket.
- region: regiao do provider.
