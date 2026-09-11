# Visão geral do recurso
Este template provisiona um bucket Amazon S3 seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-s3-<purpose>
- Bloqueio completo de acesso público (quatro flags do Public Access Block)
- Criptografia server-side habilitada por padrão (SSE-S3/AES256), configurável
- Bucket policy para negar qualquer requisição sem aws:SecureTransport (HTTPS obrigatório)
- Versionamento configurável, padrão Enabled
- Tags obrigatórias aplicadas a todos os recursos

# Tabela de variáveis
| Nome              | Tipo         | Obrigatória | Descrição                                                                 |
|-------------------|--------------|-------------|---------------------------------------------------------------------------|
| environment       | string       | Sim         | Ambiente alvo. Valores permitidos: dev, hml, prd.                         |
| system            | string       | Sim         | Identificador do sistema (minúsculas, números e hifens).                  |
| purpose           | string       | Sim         | Finalidade do bucket (minúsculas, números e hifens). Ex.: logs, assets.   |
| region            | string       | Sim         | Região AWS para o recurso. Ex.: us-east-1.                                |
| additional_tags   | map(string)  | Não         | Tags adicionais. Tags padrão da organização são sempre aplicadas.         |
| versioning_status | string       | Não         | Status do versionamento: Enabled (padrão) ou Suspended.                   |
| sse_algorithm     | string       | Não         | Algoritmo SSE: AES256 (padrão) ou aws:kms.                                |
| force_destroy     | bool         | Não         | Se true, permite destruir o bucket com objetos (uso controlado).          |

# Tabela de outputs
| Nome         | Descrição                         |
|--------------|-----------------------------------|
| bucket_name  | Nome do bucket S3.                |
| bucket_arn   | ARN do bucket S3.                 |
| bucket_id    | ID do bucket S3 (igual ao nome).  |

# Exemplo de uso
module "s3_bucket" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  purpose           = "logs"
  region            = "us-east-1"

  versioning_status = "Enabled"
  sse_algorithm     = "AES256"

  additional_tags = {
    Application = "sample-app"
  }

  # force_destroy = true
}
