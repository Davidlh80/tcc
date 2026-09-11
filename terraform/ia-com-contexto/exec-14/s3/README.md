Visão geral do recurso
Este template provisiona um bucket Amazon S3 seguindo os padrões organizacionais:
- Nome no padrão <ambiente>-<sistema>-<recurso>-<finalidade> (ex.: dev-tcc-s3-logs)
- Bloqueio de acesso público nas quatro flags do Public Access Block
- Criptografia server-side habilitada com SSE-S3 (AES256)
- Bucket policy negando requisições sem aws:SecureTransport
- Versionamento controlável por variável, com padrão Enabled
- Tags obrigatórias aplicadas automaticamente

Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome              | Tipo         | Obrigatória | Descrição                                                                 |
|-------------------|--------------|-------------|---------------------------------------------------------------------------|
| environment       | string       | Sim         | Ambiente do recurso. Valores permitidos: dev, hml, prd.                   |
| system            | string       | Sim         | Identificador do sistema (ex.: tcc). Minúsculas, números e hífens.        |
| region            | string       | Sim         | Região AWS (ex.: us-east-1).                                              |
| additional_tags   | map(string)  | Não         | Tags adicionais para complementar as tags obrigatórias.                   |
| purpose           | string       | Sim         | Finalidade do bucket (ex.: logs, assets, backups).                        |
| versioning_status | string       | Não         | Status do versionamento: Enabled (padrão) ou Suspended.                   |

Tabela de outputs (nome, descrição)
| Nome         | Descrição                          |
|--------------|------------------------------------|
| bucket_name  | Nome do bucket S3 criado.          |
| bucket_arn   | ARN do bucket S3 criado.           |
| bucket_id    | ID do bucket S3 (igual ao nome).   |

Exemplo de uso do módulo/recurso
module "s3_logs" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  purpose           = "logs"
  versioning_status = "Enabled"

  additional_tags = {
    Application = "web"
    Squad       = "platform"
  }
}
