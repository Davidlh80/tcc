Resumo
- Este template cria um bucket Amazon S3 seguro, com bloqueio de acesso público, criptografia server-side habilitada e versionamento configurável por variável.
- Aplica nomenclatura padrão: <ambiente>-<sistema>-<recurso>-<finalidade>, onde recurso é fixo s3.

Arquivos
- main.tf
- variables.tf
- outputs.tf
- versions.tf
- README.md

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS válidas no ambiente de execução (por exemplo, variáveis de ambiente AWS).

Variáveis principais
- environment (obrigatório): dev, hml ou prd.
- system (obrigatório): nome do sistema em minúsculas, números e hífens.
- purpose (opcional): finalidade do bucket. Padrão: data.
- bucket_name (opcional): nome completo do bucket. Se não informado, será montado como <environment>-<system>-s3-<purpose>.
- enable_versioning (opcional): habilita versionamento. Padrão: true.
- force_destroy (opcional): destrói o bucket mesmo com objetos. Padrão: false.
- sse_algorithm (opcional): AES256 (SSE-S3) ou aws:kms (SSE-KMS). Padrão: AES256.
- kms_key_id (opcional): Key ID/ARN para SSE-KMS. Necessário se sse_algorithm = aws:kms.
- enforce_sse_policy (opcional): nega uploads sem criptografia esperada. Padrão: true.
- tags (opcional): mapa de tags adicionais.
- aws_region (opcional): região AWS. Padrão: us-east-1.

Padrões de segurança aplicados
- Bloqueio total de acesso público ao bucket.
- Criptografia em repouso habilitada por padrão (AES256) ou KMS opcional.
- Política que nega tráfego sem TLS (aws:SecureTransport=false).
- Política opcional que nega uploads sem a criptografia definida e, se aplicável, sem a KMS Key correta.
- Propriedade de objetos forçada para o dono do bucket (BucketOwnerEnforced), eliminando ACLs.

Tags obrigatórias
- O template adiciona automaticamente:
  Project = tcc-iac-ia
  Environment = var.environment
  ManagedBy = terraform
  Owner = devops
  CostCenter = academic-research
- É possível adicionar tags extras via var.tags.

Exemplo de uso
- Defina um arquivo terraform.tfvars (opcional) com:
  environment = "dev"
  system      = "tcc"
  purpose     = "logs"
  enable_versioning = true
  sse_algorithm     = "AES256"
- Execute:
  terraform init -backend=false
  terraform validate
  terraform plan
  terraform apply

Outputs
- bucket_name: nome do bucket S3.
- bucket_arn: ARN do bucket S3.
- bucket_id: ID do bucket S3.

Observações
- Para usar SSE-KMS, defina sse_algorithm = "aws:kms" e informe kms_key_id (ARN ou ID da chave).
- O nome do bucket deve ser globalmente único na AWS.
