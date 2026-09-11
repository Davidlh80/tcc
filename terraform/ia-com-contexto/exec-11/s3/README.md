# Visão geral do recurso

Este template provisiona um bucket Amazon S3 seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-s3-<purpose>
- Segurança:
  - Bloqueio completo de acesso público (quatro flags do Public Access Block);
  - Criptografia server-side habilitada por padrão com SSE-S3 (AES256);
  - Policy do bucket negando qualquer requisição sem aws:SecureTransport (somente HTTPS);
  - Versionamento configurável por variável, com padrão Enabled.
- Tags obrigatórias aplicadas, com suporte a tags adicionais.

# Tabela de variáveis

| Nome              | Tipo        | Obrigatória | Descrição                                                                 |
|-------------------|-------------|-------------|---------------------------------------------------------------------------|
| region            | string      | Sim         | Região AWS onde os recursos serão provisionados (ex.: us-east-1).        |
| environment       | string      | Sim         | Ambiente do recurso. Valores permitidos: dev, hml, prd.                   |
| system            | string      | Sim         | Nome do sistema/aplicação ao qual o recurso pertence.                     |
| purpose           | string      | Sim         | Finalidade específica do bucket (ex.: logs, assets, backups).             |
| versioning_status | string      | Não         | Status do versionamento do bucket. Valores: Enabled (padrão) ou Suspended.|
| additional_tags   | map(string) | Não         | Mapa de tags adicionais a serem aplicadas aos recursos.                   |

# Tabela de outputs

| Nome         | Descrição                                      |
|--------------|-------------------------------------------------|
| bucket_name  | Nome do bucket S3 criado.                       |
| bucket_arn   | ARN do bucket S3 criado.                        |
| bucket_id    | ID do bucket S3 criado (normalmente igual ao nome). |

# Exemplo de uso do módulo/recurso

module "s3_bucket" {
  source = "./"

  region            = "us-east-1"
  environment       = "dev"
  system            = "tcc"
  purpose           = "logs"
  versioning_status = "Enabled"

  additional_tags = {
    Team = "platform"
  }
}

# Observações
- O nome do bucket seguirá o padrão: dev-tcc-s3-logs (ajuste os valores conforme necessário).
- Não há backend remoto configurado; utilize localmente ou configure conforme sua necessidade fora deste template.
