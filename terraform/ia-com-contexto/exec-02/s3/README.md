# Blueprint Terraform — S3 Bucket seguro

Este template cria um bucket Amazon S3 alinhado ao contexto organizacional, com bloqueio de acesso público, criptografia server-side, opção de versionamento e tags padronizadas.

Padrão de nomenclatura
- Formato: <ambiente>-<sistema>-<recurso>-<finalidade>
- Exemplo: dev-tcc-s3-logs
- Neste módulo, o nome é construído como: ${var.environment}-${var.system}-s3-${var.purpose}

Requisitos atendidos
- Cria bucket S3 com nome padronizado
- Bloqueia acesso público (Public Access Block)
- Criptografia server-side (SSE-S3 AES256) habilitada por padrão
- Versionamento configurável via variável
- Tags obrigatórias aplicadas
- Política para negar tráfego sem TLS (SecureTransport)
- Sem backend remoto e sem dependência de credenciais para validação sintática

Uso
1) Ajuste variáveis (exemplo tfvars):
environment     = "dev"
system          = "tcc"
purpose         = "logs"
aws_region      = "us-east-1"
enable_versioning = true
additional_tags = {
  Team = "platform"
}

2) Comandos:
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Variáveis
- aws_region (string): Região AWS. Padrão: us-east-1.
- environment (string): dev | hml | prd. Obrigatória.
- system (string): Sistema/aplicação (minúsculas, números, hífen). Obrigatória.
- purpose (string): Finalidade do bucket (minúsculas, números, hífen). Obrigatória.
- enable_versioning (bool): Habilita versionamento. Padrão: true.
- force_destroy (bool): Permite destruir bucket com objetos. Padrão: false. Use com cautela.
- additional_tags (map(string)): Tags adicionais opcionais.

Tags obrigatórias aplicadas
- Project = "tcc-iac-ia"
- Environment = var.environment
- ManagedBy = "terraform"
- Owner = "devops"
- CostCenter = "academic-research"
- Name = nome do bucket
- + additional_tags (quando fornecido)

Outputs
- bucket_name: Nome do bucket.
- bucket_arn: ARN do bucket.
- bucket_id: ID do bucket.

Observações
- Nomes de buckets S3 são globais. Garanta unicidade conforme seu ambiente.
- Por padrão, este template nega acessos sem TLS e bloqueia acesso público.
- A criptografia default usa SSE-S3 (AES256). Caso precise de KMS, ajuste a configuração conforme políticas internas.
