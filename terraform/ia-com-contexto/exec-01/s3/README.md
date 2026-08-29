Blueprint Terraform — Bucket Amazon S3 seguro e padronizado

Descrição
- Cria um bucket S3 seguindo o padrão organizacional de nomenclatura e tags, com bloqueio de acesso público, criptografia server-side por padrão e versionamento opcional.

Padrão de nomenclatura
- <ambiente>-<sistema>-<recurso>-<finalidade>(-<sufixo>)
- Exemplo: dev-tcc-s3-logs
- Observação: nomes de bucket são globais na AWS. Use name_suffix para garantir unicidade quando necessário.

Requisitos
- Terraform >= 1.4.0
- Provider AWS >= 5.40.0
- Sem backend remoto
- Sintaxe compatível com terraform fmt, terraform init -backend=false e terraform validate

Recursos criados
- aws_s3_bucket
- aws_s3_bucket_public_access_block
- aws_s3_bucket_ownership_controls (BucketOwnerEnforced)
- aws_s3_bucket_versioning (configurável)
- aws_s3_bucket_server_side_encryption_configuration (SSE-S3 ou SSE-KMS)
- aws_s3_bucket_policy (nega tráfego sem TLS e reforça headers de criptografia)

Segurança e governança
- Acesso público bloqueado (todas as flags)
- Criptografia server-side habilitada por padrão:
  - AES256 por padrão
  - Optionally aws:kms quando sse_algorithm = "aws:kms" (exige kms_key_arn)
- Política nega:
  - Qualquer ação via HTTP (sem TLS)
  - PutObject sem os headers de criptografia corretos
- Versionamento configurável (enable_versioning)
- ACLs desabilitadas via BucketOwnerEnforced

Variáveis principais
- region (string): Região AWS (ex.: sa-east-1)
- environment (string): dev, hml ou prd
- system (string): nome do sistema/aplicação (minúsculo, números e hífens)
- purpose (string): finalidade do bucket (ex.: logs, assets)
- name_suffix (string, opcional): sufixo para unicidade global
- enable_versioning (bool): habilita versionamento (default: true)
- sse_algorithm (string): AES256 (padrão) ou aws:kms
- kms_key_arn (string): ARN da KMS Key quando sse_algorithm = aws:kms
- force_destroy (bool): destrói bucket com objetos (default: false)
- additional_tags (map(string)): tags extras

Tags obrigatórias aplicadas
- Project = "tcc-iac-ia"
- Environment = var.environment
- ManagedBy = "terraform"
- Owner = "devops"
- CostCenter = "academic-research"

Outputs
- bucket_name
- bucket_arn
- bucket_id

Exemplo de uso
- Arquivos no mesmo diretório.
- Ajuste variáveis conforme seu ambiente.

Exemplo de terraform.tfvars (ilustrativo)
- region = "sa-east-1"
- environment = "dev"
- system = "tcc"
- purpose = "logs"
- name_suffix = "equipe-a"  # opcional para unicidade
- enable_versioning = true
- sse_algorithm = "AES256"
- additional_tags = {
    DataClass = "confidential"
  }

Comandos
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Observações
- Para usar SSE-KMS, defina sse_algorithm = "aws:kms" e informe kms_key_arn com a chave apropriada e permissões no KMS.
- Evite definir force_destroy = true em produção, pois permite destruição mesmo com objetos no bucket.
