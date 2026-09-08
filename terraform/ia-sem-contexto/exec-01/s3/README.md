Blueprint Terraform: Amazon S3 Bucket

Descrição
- Provisiona um bucket S3 com foco em segurança por padrão:
  - Bloqueio de acesso público (todas as flags ativadas por padrão)
  - Criptografia em repouso habilitada (AES256 por padrão, opcional aws:kms)
  - Versionamento habilitado por padrão
  - Política que nega tráfego sem TLS
  - Política que exige criptografia do lado do servidor nos uploads
  - Regra de ciclo de vida para abortar uploads multipart incompletos
  - Tags básicas e personalizáveis

Arquivos
- versions.tf: versões mínimas do Terraform e provider AWS
- variables.tf: variáveis de entrada com validações
- main.tf: provider, recursos S3 e políticas
- outputs.tf: saídas úteis
- README.md: instruções de uso

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS exportadas no ambiente (ex.: AWS_PROFILE ou AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY)
- Permissões para criar e configurar S3

Como usar (exemplo simples)
1) Ajuste as variáveis necessárias (principalmente bucket_name). Exemplo de terraform.tfvars:
   bucket_name = "meu-bucket-unico-global-123"
   aws_region  = "us-east-1"

2) Inicialize e valide:
   terraform init -backend=false
   terraform validate

3) Planeje e aplique:
   terraform plan
   terraform apply

Variáveis principais
- bucket_name (obrigatória): nome globalmente único do bucket.
- aws_region: região AWS (padrão: us-east-1).
- versioning_enabled: habilita versionamento (padrão: true).
- force_destroy: permite destruir bucket com objetos (padrão: false).
- sse_algorithm: AES256 ou aws:kms (padrão: AES256).
- kms_key_id: opcional quando aws:kms (usa chave gerenciada pela AWS se não informado).
- bucket_key_enabled: ativa S3 Bucket Keys com KMS (padrão: true).
- logging_enabled: ativa logging (padrão: false).
- logging_bucket: bucket de destino para logs (requerido se logging_enabled=true).
- logging_prefix: prefixo para objetos de log (padrão: s3-access-logs/).
- lifecycle_enabled: aplica regra de ciclo de vida padrão (padrão: true).
- abort_incomplete_multipart_upload_days: dias para abortar uploads incompletos (padrão: 7).
- noncurrent_version_expiration_days: expira versões antigas após X dias (opcional).
- enforce_ssl_only: nega requests sem TLS (padrão: true).
- enforce_sse: exige SSE nos uploads (padrão: true).
- tags: mapa de tags adicionais (padrão: vazio).

Observações de segurança e operação
- Nome do bucket é global: escolha um que não exista em nenhuma conta/partição AWS.
- force_destroy=false por padrão para evitar perdas acidentais.
- Ao usar aws:kms:
  - Informe kms_key_id para usar uma chave específica, ou deixe vazio para usar a chave gerenciada pela AWS.
  - A política do bucket nega uploads com KMS diferente se kms_key_id for informado.
- Logging:
  - Requer um bucket de logs existente na mesma região e permissões adequadas.
- Políticas:
  - Por padrão, o template aplica políticas para exigir TLS e criptografia do lado do servidor.

Outputs
- bucket_id, bucket_arn, bucket_name
- bucket_domain_name, bucket_regional_domain_name
- versioning_status, encryption_algorithm

Limitações
- O template não configura backend remoto.
- A validação sintática não depende de credenciais; porém, para aplicar os recursos é necessário ter permissões na conta AWS alvo.
