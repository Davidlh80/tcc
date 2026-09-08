Resumo
Blueprint Terraform para provisionar um bucket Amazon S3 com padrões seguros:
- Criptografia em repouso habilitada por padrão (AES256 ou KMS opcional)
- Bloqueio de acesso público (todas as opções ativas por padrão)
- Versionamento opcional (habilitado por padrão)
- Política que nega acesso sem TLS (HTTPS) opcional (habilitada por padrão)
- Regras de lifecycle para abortar uploads multipart incompletos e expirar versões antigas (opcional)
- Logging de acesso do S3 opcional para um bucket de destino

Pré-requisitos
- Terraform >= 1.3
- Provider AWS >= 5.0
- Credenciais AWS válidas no ambiente (para aplicar)

Arquivos
- main.tf: recursos AWS S3 e configurações
- variables.tf: variáveis configuráveis com validações
- outputs.tf: saídas úteis
- versions.tf: versões e providers requeridos
- README.md: instruções de uso

Variáveis principais
- region: região AWS (padrão: us-east-1)
- bucket_name: nome globalmente único do bucket (obrigatório)
- force_destroy: permite destruir bucket com objetos (padrão: false)
- enable_versioning: habilita versionamento (padrão: true)
- sse_algorithm: AES256 ou aws:kms (padrão: AES256)
- sse_kms_key_arn: ARN da KMS key quando aws:kms (opcional)
- block_public_acls, ignore_public_acls, block_public_policy, restrict_public_buckets: controles de acesso público (padrão: true)
- logging_target_bucket: bucket de logs (opcional)
- logging_target_prefix: prefixo de logs (opcional)
- abort_incomplete_multipart_days: dias para abortar uploads multipart (padrão: 7)
- noncurrent_version_expiration_days: dias para expirar versões antigas (0 desabilita)
- create_bucket_policy_https_only: nega acesso sem TLS (padrão: true)
- tags: mapa de tags adicionais

Como usar
1) Defina as variáveis desejadas. Exemplo mínimo:
   bucket_name = "meu-bucket-unico-12345"

2) Inicialize o Terraform sem backend remoto:
   terraform init -backend=false

3) Visualize o plano:
   terraform plan -var 'bucket_name=meu-bucket-unico-12345'

4) Aplique:
   terraform apply -var 'bucket_name=meu-bucket-unico-12345'

Observações
- O nome do bucket deve ser globalmente único na AWS.
- Para usar KMS, informe sse_algorithm="aws:kms" e o ARN em sse_kms_key_arn.
- O Server Access Logging requer um bucket de destino pré-existente que aceite as permissões de log-delivery (ACLs no bucket de destino).
- A política HTTPS-only nega qualquer acesso sem TLS ao bucket e aos objetos.
- Não é configurado backend remoto; ajuste conforme seu uso.
- Não há dependência de credenciais reais para validação sintática (terraform validate). Contudo, para aplicar é necessário ter credenciais AWS.

Exemplos de execução
- Criar bucket simples e seguro:
  terraform apply -var 'bucket_name=org-demo-bucket-001'

- Criar bucket com KMS e versionamento desabilitado:
  terraform apply -var 'bucket_name=org-demo-bucket-002' -var 'sse_algorithm=aws:kms' -var 'sse_kms_key_arn=arn:aws:kms:us-east-1:111122223333:key/abcd-efgh' -var 'enable_versioning=false'

- Habilitar logging para um bucket de logs:
  terraform apply -var 'bucket_name=org-demo-bucket-003' -var 'logging_target_bucket=org-logs-bucket' -var 'logging_target_prefix=s3-logs/'

Saídas
- bucket_id, bucket_arn, bucket_domain_name, bucket_regional_domain_name
- versioning_enabled, bucket_region, logging_enabled

Segurança por padrão
- Bloqueio de acesso público ativo
- Criptografia em repouso habilitada
- Política que impõe uso de HTTPS
- Lifecycle para reduzir riscos de custos de uploads incompletos

Limitações
- A criação pode falhar se o bucket_name já existir em outra conta/região.
- O módulo não cria KMS Key nem bucket de logs; forneça recursos existentes se necessário.
