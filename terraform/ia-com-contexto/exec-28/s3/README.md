Visão geral do recurso
Este template provisiona um bucket Amazon S3 padronizado e seguro, seguindo as diretrizes organizacionais:
- Nomenclatura: <ambiente>-<sistema>-s3-<finalidade>
- Bloqueio total de acesso público (quatro flags do Public Access Block)
- Criptografia server-side habilitada (SSE-S3/AES256)
- Bucket policy negando acesso sem uso de aws:SecureTransport
- Versionamento configurável por variável, padrão Enabled
- Tags obrigatórias aplicadas a todos os recursos que suportam tags

Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome              | Tipo        | Obrigatória | Descrição                                                                 |
|-------------------|-------------|-------------|---------------------------------------------------------------------------|
| environment       | string      | Sim         | Ambiente alvo do recurso (dev, hml, prd).                                 |
| system            | string      | Sim         | Identificador do sistema/aplicação (minúsculas e hifens, ex.: tcc).       |
| region            | string      | Sim         | Região AWS (ex.: us-east-1).                                              |
| purpose           | string      | Sim         | Finalidade do recurso (ex.: logs, data, backups).                         |
| versioning_status | string      | Não         | Status do versionamento do bucket: Enabled (padrão) ou Suspended.         |
| additional_tags   | map(string) | Não         | Tags adicionais a serem aplicadas aos recursos.                            |

Tabela de outputs (nome, descrição)
| Nome         | Descrição                    |
|--------------|------------------------------|
| bucket_name  | Nome do bucket S3 criado.    |
| bucket_arn   | ARN do bucket S3 criado.     |
| bucket_id    | ID do bucket S3 criado.      |

Exemplo de uso do módulo/recurso
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

# Comandos
# terraform init -backend=false
# terraform validate
# terraform apply
