Blueprint Terraform — Amazon S3 Bucket

Descrição
Cria um bucket Amazon S3 com padrões seguros: bloqueio de acesso público, criptografia do lado do servidor, versionamento (opcional), política que nega acesso sem TLS, e opções de logging e lifecycle simples.

Arquivos
- versions.tf: Restrições de versão do Terraform e provider AWS.
- variables.tf: Variáveis configuráveis com validações.
- main.tf: Definição dos recursos AWS.
- outputs.tf: Saídas úteis.
- README.md: Instruções de uso.

Pré-requisitos
- Terraform >= 1.3
- Provider AWS ~> 5.0
- Credenciais AWS configuradas no ambiente (para aplicar)

Uso rápido
1) Ajuste as variáveis necessárias, especialmente bucket_name e opcionalmente region.
2) Inicialize e valide:
   terraform init -backend=false
   terraform validate
3) Planeje e aplique:
   terraform plan
   terraform apply

Exemplo de uso
terraform {
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-east-1"
}

module "bucket" {
  source = "./."  # se você colar estes arquivos num diretório de módulo

  bucket_name        = "meu-bucket-unico-global-123456"
  region             = "us-east-1"
  versioning_enabled = true

  sse_algorithm          = "AES256"
  sse_bucket_key_enabled = true

  public_access_block = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

  logging = {
    enabled       = false
    target_bucket = ""
    target_prefix = "s3-access-logs/"
  }

  lifecycle = {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 7
    noncurrent_version_expiration_days     = 365
  }

  tags = {
    environment = "dev"
    project     = "s3-blueprint"
  }
}

Notas de segurança
- O acesso público é bloqueado por padrão.
- O bucket aplica criptografia do lado do servidor (AES256 por padrão).
- Uma política nega qualquer requisição não-TLS (aws:SecureTransport=false).
- Para usar KMS, defina sse_algorithm = "aws:kms" e informe kms_key_arn.

Logging de acesso
- Para habilitar logging, defina logging.enabled = true e logging.target_bucket com o nome/ID de um bucket já existente destinado a logs.

Limitações
- O nome do bucket deve ser globalmente único.
- Este template não cria chave KMS automaticamente; forneça kms_key_arn se optar por aws:kms.

Saídas
- bucket_id, bucket_arn, bucket_name
- bucket_domain_name, bucket_regional_domain_name
- versioning_status, sse_algorithm

Comandos úteis
- terraform fmt
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply
