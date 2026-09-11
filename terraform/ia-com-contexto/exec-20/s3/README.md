# Visão geral do recurso

Este template provisiona um bucket Amazon S3 seguindo o padrão organizacional:
- Nomeação: <environment>-<system>-s3-<purpose>
- Bloqueio completo de acesso público (quatro flags do Public Access Block)
- Criptografia server-side habilitada com SSE-S3 (AES256)
- Bucket Policy negando requisições sem aws:SecureTransport
- Versionamento configurável por variável, padrão Enabled
- Tags obrigatórias aplicadas a todos os recursos que suportam tags

# Tabela de variáveis

| Nome              | Tipo         | Obrigatória | Descrição |
|-------------------|--------------|-------------|-----------|
| environment       | string       | Sim         | Ambiente alvo. Valores permitidos: dev, hml, prd. |
| system            | string       | Sim         | Identificador curto do sistema/produto (ex.: tcc). Use apenas [a-z0-9-]. |
| region            | string       | Sim         | Região AWS onde os recursos serão criados (ex.: us-east-1). |
| additional_tags   | map(string)  | Não         | Mapa de tags adicionais a serem aplicadas ao bucket. |
| purpose           | string       | Sim         | Finalidade do recurso para compor o nome (ex.: logs, assets, backups). |
| versioning_status | string       | Não         | Status do versionamento do bucket: Enabled ou Suspended. Padrão: Enabled. |
| force_destroy     | bool         | Não         | Se true, permite destruir o bucket mesmo que contenha objetos. Padrão: false. |

Tags obrigatórias aplicadas automaticamente:
- Project = "tcc-iac-ia"
- Environment = var.environment
- ManagedBy = "terraform"
- Owner = "devops"
- CostCenter = "academic-research"

# Tabela de outputs

| Nome         | Descrição |
|--------------|-----------|
| bucket_name  | Nome completo do bucket S3 criado. |
| bucket_arn   | ARN do bucket S3. |
| bucket_id    | ID do bucket S3 (normalmente igual ao nome). |

# Exemplo de uso

module "s3_bucket" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  purpose           = "logs"
  versioning_status = "Enabled"

  additional_tags = {
    Team = "platform"
  }
}
