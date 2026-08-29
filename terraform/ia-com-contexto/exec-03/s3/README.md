Propósito
Template Terraform para provisionar um bucket Amazon S3 aderente ao contexto organizacional, com foco em segurança, governança e padronização.

Recursos e padrões aplicados
- Criação de bucket S3 com nomenclatura: <ambiente>-<sistema>-s3-<finalidade>
- Bloqueio de acesso público (Public Access Block)
- Propriedade de objetos: BucketOwnerEnforced (ACLs desabilitadas)
- Criptografia server-side por padrão (SSE-S3 AES256)
- Versionamento configurável por variável
- Política do bucket para:
  - Negar tráfego sem TLS (aws:SecureTransport=false)
  - Negar upload de objetos sem criptografia ou com algoritmo inválido
- Tags obrigatórias aplicadas:
  - Project = tcc-iac-ia
  - Environment = var.environment
  - ManagedBy = terraform
  - Owner = devops
  - CostCenter = academic-research
- Suporte a tags adicionais via variável
- Saídas com nome, ARN e ID do bucket

Variáveis
- environment (string): dev, hml, prd. Obrigatória.
- system (string): identificador do sistema/aplicação. Regras: minúsculas, números e hífens; entre 3 e 24; não iniciar/terminar com hífen. Obrigatória.
- purpose (string): finalidade do bucket. Mesmo padrão de system. Obrigatória.
- enable_versioning (bool): habilita versionamento. Padrão: true.
- aws_region (string): região AWS, ex.: us-east-1. Padrão: us-east-1.
- force_destroy (bool): permite destruir bucket com objetos. Padrão: false.
- tags (map(string)): tags adicionais opcionais.

Padrão de nomenclatura
Nome do bucket: <environment>-<system>-s3-<purpose>
Exemplos: dev-tcc-s3-logs, prd-erp-s3-backup

Pré-requisitos
- Terraform 1.4.0 ou superior
- Provider AWS 5.x
- Credenciais válidas na máquina/local (não são necessárias para validação sintática)

Como usar
1) Ajuste as variáveis no arquivo terraform.tfvars ou via CLI.
2) Comandos essenciais:
   - terraform init -backend=false
   - terraform validate
   - terraform plan
   - terraform apply

Exemplo de tfvars
environment = "dev"
system      = "tcc"
purpose     = "logs"
aws_region  = "us-east-1"
enable_versioning = true
tags = {
  Squad = "core-platform"
}

Notas de segurança
- O acesso público é bloqueado em nível de bucket.
- ACLs são desabilitadas com BucketOwnerEnforced.
- Todo upload sem criptografia ou sem TLS é negado por política.
- force_destroy = false por padrão para evitar destruição acidental de dados.

Outputs
- bucket_name: nome do bucket.
- bucket_arn: ARN do bucket.
- bucket_id: ID do bucket.
