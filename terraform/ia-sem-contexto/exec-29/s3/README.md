Blueprint Terraform: Amazon S3 Bucket

Descrição
Este template cria um bucket S3 com padrões seguros:
- Bloqueio de acesso público (Public Access Block) habilitado por padrão
- Propriedade de objetos forçada ao dono do bucket (BucketOwnerEnforced), desativando ACLs
- Criptografia em repouso padrão (SSE-S3 AES256 ou SSE-KMS)
- Versionamento habilitado por padrão
- Regra de lifecycle para abortar uploads multipart incompletos
- Bucket policy opcional para exigir TLS e negar uploads sem criptografia

Pré-requisitos
- Terraform >= 1.4.0
- Provider AWS >= 5.0
- Credenciais AWS configuradas no ambiente (perfil, variáveis de ambiente, etc.)

Arquivos
- main.tf: Recursos AWS para o bucket S3 e configurações relacionadas
- variables.tf: Variáveis de entrada com validações
- outputs.tf: Saídas úteis do bucket
- versions.tf: Versões mínimas do Terraform e provider
- README.md: Instruções e explicações

Como usar
1) Ajuste as variáveis conforme necessário (ver seção Variáveis).
2) Execute:
   terraform init -backend=false
   terraform validate
   terraform plan -out=tfplan
   terraform apply tfplan
3) Para destruir:
   terraform destroy

Variáveis principais
- bucket_name (string, obrigatório): Nome globalmente único do bucket.
- region (string, padrão: us-east-1): Região AWS dos recursos.
- tags (map(string), opcional): Tags adicionais.
- enable_versioning (bool, padrão: true): Habilita versionamento.
- force_destroy (bool, padrão: false): Permite destruir com objetos.
- block_public_access (bool, padrão: true): Bloqueia acesso público (4 flags).
- sse_algorithm (string, padrão: AES256): AES256 ou aws:kms.
- kms_key_arn (string, opcional): ARN da KMS Key quando sse_algorithm = aws:kms.
- attach_bucket_policy (bool, padrão: true): Anexa policy exigindo TLS e nega uploads sem SSE.
- logging_enabled (bool, padrão: false): Habilita Server Access Logging.
- logging_target_bucket (string, opcional): Bucket de destino para logs (requerido se logging_enabled = true).
- logging_target_prefix (string, opcional): Prefixo para logs (padrão: <bucket_name>/).
- abort_incomplete_mpu_days (number, padrão: 7): Aborta uploads multipart incompletos após N dias.
- noncurrent_expiration_days (number|null, padrão: null): Expira versões não correntes após N dias (se versionamento ativo).

Decisões de segurança padrão
- Acesso público bloqueado por padrão.
- Criptografia em repouso habilitada por padrão.
- Policy nega tráfego sem TLS e uploads sem cabeçalho de criptografia.
- ACLs desativadas via BucketOwnerEnforced para reduzir risco de exposição.

Observações sobre SSE-KMS
- Se sse_algorithm = aws:kms, informe kms_key_arn com a chave já existente e permissões adequadas para o serviço S3 e para os clientes que farão uploads.
- bucket_key_enabled é ativado automaticamente para SSE-KMS para otimização de custos/desempenho no S3.

Logging de acesso
- Para habilitar, defina logging_enabled = true e forneça logging_target_bucket.
- O bucket de destino deve existir e permitir escrita (via ACL do bucket de logs ou bucket policy apropriada).
- O destino não pode ser o mesmo bucket de origem.

Limitações
- Este template não cria a KMS Key nem o bucket de logs de destino.
- Nomes de bucket precisam ser únicos globalmente.

Exemplos de execução
- Criar um bucket simples com AES256 na us-east-1:
  - Defina bucket_name = "meu-bucket-unico-123"
  - Execute os comandos da seção Como usar

- Criar um bucket com SSE-KMS:
  - Defina sse_algorithm = "aws:kms" e kms_key_arn = "arn:aws:kms:REGIAO:CONTA:key/ID-DA-CHAVE"

Saídas
- bucket_id, bucket_name, bucket_arn
- bucket_domain_name, bucket_regional_domain_name
- versioning_status, encryption_algorithm
- bucket_policy_id (se a policy for anexada)
