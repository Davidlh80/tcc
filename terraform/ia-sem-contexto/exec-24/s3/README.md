Nome
Blueprint Terraform para provisionar um bucket Amazon S3 com configuracoes seguras por padrao.

Recursos criados
- Bucket S3 com bloqueio de acesso publico
- Controles de propriedade do bucket (BucketOwnerEnforced)
- Versionamento configuravel (habilitado por padrao)
- Criptografia do lado do servidor (SSE-S3 por padrao; opcional SSE-KMS)
- Politica do bucket para negar acesso sem TLS (HTTPS)
- Regras de ciclo de vida opcionais (abortam uploads multipart, expiram versoes nao correntes e, opcionalmente, objetos atuais)

Requisitos
- Terraform >= 1.4.0
- Provider AWS ~> 5.x
- Credenciais AWS validas exportadas no ambiente ou configuradas de outra forma (nao necessarias para terraform validate)

Inputs principais
- aws_region: Regiao AWS (padrao: us-east-1)
- bucket_name: Nome globalmente unico do bucket (obrigatorio)
- versioning_enabled: Habilita versionamento (padrao: true)
- sse_algorithm: AES256 (SSE-S3) ou aws:kms (SSE-KMS) (padrao: AES256)
- kms_key_id: ID/ARN da chave KMS quando sse_algorithm=aws:kms
- lifecycle_enabled: Habilita regra de ciclo de vida padrao (padrao: true)
- abort_incomplete_multipart_upload_days: Abortar uploads multipart incompletos apos N dias (padrao: 7)
- noncurrent_version_expiration_days: Expirar versoes nao correntes apos N dias (padrao: 180)
- expiration_days: Expirar objetos atuais apos N dias (padrao: 0, desabilitado)
- force_destroy: Permite destruir bucket com objetos (padrao: false)
- object_lock_enabled: Habilita Object Lock (padrao: false; so na criacao)
- tags: Mapa de tags a aplicar

Outputs
- bucket_id, bucket_arn, bucket_name
- bucket_domain_name, bucket_regional_domain_name
- bucket_region
- versioning_status
- sse_algorithm, kms_key_id

Como usar (exemplo basico)
1) Defina variaveis (exemplo com terraform.tfvars):
bucket_name = "meu-bucket-exemplo-123456"
aws_region  = "us-east-1"
tags = {
  Project = "demo"
  Env     = "dev"
}

2) Inicialize e valide:
terraform init -backend=false
terraform validate

3) Planeje e aplique:
terraform plan
terraform apply

Observacoes de seguranca e operacao
- O acesso publico e bloqueado por padrao.
- A politica nega operacoes sem HTTPS (aws:SecureTransport=false).
- Criptografia SSE-S3 (AES256) e padrao. Use aws:kms e informe kms_key_id para chaves gerenciadas pelo cliente.
- Se habilitar object_lock_enabled, o versionamento deve permanecer habilitado e essa configuracao nao pode ser alterada depois.
- force_destroy=false por padrao para evitar delecoes acidentais. Ajuste conscientemente.

Limitacoes
- O nome do bucket deve ser unico em toda a AWS.
- Sem backend remoto (por exigencia do experimento).
