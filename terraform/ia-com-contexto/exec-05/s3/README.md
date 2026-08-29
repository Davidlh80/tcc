# Blueprint Terraform — S3 com segurança e governança

Este template cria um bucket Amazon S3 seguindo o contexto organizacional definido, com foco em segurança, padronização e governança.

Padrão de nomenclatura aplicado automaticamente:
<ambiente>-<sistema>-<recurso>-<finalidade>
Exemplo: dev-tcc-s3-logs

Recursos e configurações:
- Bucket S3 com nome padronizado e sanitizado para atender às regras do S3
- Bloqueio de acesso público (todas as opções True)
- Criptografia server-side padrão (SSE-S3 AES256)
- Versionamento configurável por variável (habilitado por padrão)
- Política para negar requisições sem TLS (DenyInsecureTransport)
- Object Ownership: BucketOwnerEnforced (ACLs desabilitadas)
- Tags obrigatórias aplicadas conforme contexto e suporte a tags adicionais

Variáveis:
- environment (string) — Ambiente (dev, hml, prd). Obrigatória.
- system (string) — Sistema/aplicação (minúsculo, números e hífen). Obrigatória.
- purpose (string) — Finalidade do bucket (minúsculo, números e hífen). Obrigatória.
- enable_versioning (bool) — Habilita versionamento (default: true).
- aws_region (string) — Região AWS (ex.: us-east-1). Obrigatória.
- additional_tags (map(string)) — Tags extras, mescladas às obrigatórias.

Tags obrigatórias aplicadas:
- Project     = "tcc-iac-ia"
- Environment = var.environment
- ManagedBy   = "terraform"
- Owner       = "devops"
- CostCenter  = "academic-research"

Outputs:
- bucket_name — Nome do bucket.
- bucket_arn — ARN do bucket.
- bucket_id — ID do bucket (igual ao nome).

Como usar:
1) Ajuste as variáveis (via tfvars ou -var).
2) Execute:
   - terraform init -backend=false
   - terraform validate
   - terraform plan -var 'environment=dev' -var 'system=tcc' -var 'purpose=logs' -var 'aws_region=us-east-1'
   - terraform apply

Notas:
- O nome do bucket é automaticamente derivado de: <environment>-<system>-s3-<purpose>, sanitizado e limitado a 63 caracteres para atender às regras do S3.
- Evite colisões de nomes globais de S3 ajustando system/purpose quando necessário.
- Este template não configura backend remoto conforme a diretriz.
