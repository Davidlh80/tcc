Visão geral do recurso
Este template provisiona um bucket Amazon S3 seguindo a política interna: nomeação padronizada <environment>-<system>-s3-<purpose>, bloqueio completo de acesso público (quatro flags), criptografia server-side com SSE-S3 (AES256), negação explícita de requisições sem TLS (aws:SecureTransport = false) e versionamento configurável com padrão Enabled. As tags obrigatórias corporativas são aplicadas automaticamente e prevalecem sobre quaisquer tags adicionais.

Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome              | Tipo        | Obrigatória | Descrição                                                                                  |
|-------------------|-------------|-------------|--------------------------------------------------------------------------------------------|
| environment       | string      | Sim         | Ambiente de implantação. Valores permitidos: dev, hml, prd.                                |
| system            | string      | Sim         | Identificador do sistema/aplicação (minúsculas, números e hifens). Ex.: tcc                |
| region            | string      | Sim         | Região AWS. Ex.: us-east-1                                                                 |
| additional_tags   | map(string) | Não         | Tags adicionais. Tags mandatórias corporativas prevalecem em caso de conflito.             |
| purpose           | string      | Sim         | Finalidade do bucket (minúsculas, números e hifens). Ex.: logs, artifacts, backups         |
| versioning_status | string      | Não         | Status do versionamento: Enabled (padrão) ou Suspended.                                    |
| sse_algorithm     | string      | Não         | Algoritmo SSE. Política: AES256 (SSE-S3).                                                  |
| force_destroy     | bool        | Não         | Permite destruir o bucket mesmo se houver objetos. Padrão: false.                          |

Tabela de outputs (nome, descrição)
| Nome         | Descrição                              |
|--------------|----------------------------------------|
| bucket_name  | Nome do bucket S3 provisionado.        |
| bucket_arn   | ARN do bucket S3 provisionado.         |
| bucket_id    | ID do bucket S3 (igual ao nome).       |

Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "logs"

  # Opcional
  versioning_status = "Enabled"
  force_destroy     = false

  additional_tags = {
    Team        = "platform"
    DataClass   = "internal"
    Application = "example-app"
  }
}

# Após aplicar:
# - Nome do bucket: dev-tcc-s3-logs
# - Criptografia: SSE-S3 (AES256)
# - Public Access Block: 4 flags habilitadas
# - Policy: nega tráfego sem TLS (aws:SecureTransport = false)
# - Versionamento: Enabled (padrão)
