Blueprint Terraform: Bucket Amazon S3

Descrição
- Cria um bucket S3 com:
  - Bloqueio completo de acesso público.
  - Propriedade de objetos forçada ao dono do bucket (ACLs desabilitadas).
  - Criptografia em repouso por padrão (SSE-S3 ou SSE-KMS).
  - Versionamento (ativado por padrão).
  - Regras de ciclo de vida opcionais (expiração de versões antigas e aborto de uploads incompletos).
  - Política opcional para exigir TLS (HTTPS) em todas as requisições.
  - Tags padronizadas.

Pré-requisitos
- Terraform 1.3+.
- Credenciais AWS válidas exportadas no ambiente (ex.: AWS_PROFILE, AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY).
- Permissões para criar e gerenciar recursos S3 e políticas IAM relacionadas.

Arquivos
- main.tf: Definição dos recursos.
- variables.tf: Variáveis configuráveis com validações.
- outputs.tf: Saídas úteis do deployment.
- versions.tf: Versões de Terraform e providers.
- README.md: Instruções e notas.

Uso rápido
1) Ajuste as variáveis necessárias, principalmente bucket_name (deve ser globalmente único).
2) Comandos básicos:
- terraform init -backend=false
- terraform validate
- terraform plan -var bucket_name=meu-bucket-unico-123 -var region=us-east-1
- terraform apply -var bucket_name=meu-bucket-unico-123 -auto-approve

Variáveis principais
- bucket_name (obrigatória): nome globalmente único do bucket.
- region (padrão: us-east-1): região AWS.
- environment (padrão: dev): valor usado em tags.
- versioning_enabled (padrão: true): habilita/suspende versionamento.
- sse_algorithm (padrão: AES256): AES256 ou aws:kms.
- kms_key_id (opcional): obrigatório se sse_algorithm for aws:kms.
- force_destroy (padrão: false): permite destruir bucket com objetos (use com cautela).
- logging_target_bucket (opcional): define bucket de destino para access logs.
- logging_target_prefix (padrão: logs/): prefixo dos logs.
- enable_lifecycle_rules (padrão: true): habilita regras de ciclo de vida.
- noncurrent_version_expiration_days (padrão: 90): expiração de versões antigas.
- abort_incomplete_multipart_upload_days (padrão: 7): aborta uploads incompletos.
- attach_tls_enforce_policy (padrão: true): aplica política que exige TLS.
- tags (mapa): tags adicionais.

Notas de segurança e operação
- Por padrão, o bucket é privado, com bloqueio total de acesso público.
- Criptografia em repouso é aplicada automaticamente. Para chaves KMS gerenciadas pelo cliente, forneça kms_key_id e garanta permissões adequadas.
- O versionamento aumenta resiliência contra exclusões acidentais; suspenda se não for necessário.
- force_destroy é false por padrão para evitar perda acidental de dados.
- Se habilitar logging, o bucket de destino deve existir e permitir writes do bucket de origem (logs de acesso S3).

Limitações conhecidas
- O nome do bucket deve ser único globalmente e obedecer às regras do S3.
- O template não configura backend remoto, por isso utilize -backend=false no init conforme indicado.

Exemplos de execução
- Plano com valores mínimos:
  terraform plan -var bucket_name=empresa-labs-artifacts-123
- Aplicando com SSE-KMS:
  terraform apply -var bucket_name=empresa-labs-secure-001 -var sse_algorithm=aws:kms -var kms_key_id=arn:aws:kms:us-east-1:111122223333:key/abcd-1234-efgh-5678
- Habilitando access logs:
  terraform apply -var bucket_name=empresa-labs-logs-001 -var logging_target_bucket=bucket-de-logs -var logging_target_prefix=meu-bucket/

Saídas
- bucket_id, bucket_arn, bucket_name, bucket_domain_name, bucket_regional_domain_name, versioning_status, encryption_algorithm.
