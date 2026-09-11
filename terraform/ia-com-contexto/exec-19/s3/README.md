Visão geral do recurso
Este template provisiona um bucket Amazon S3 seguindo o padrão organizacional:
- Nome no formato <environment>-<system>-s3-<purpose>
- Bloqueio completo de acesso público (quatro flags do Public Access Block)
- Criptografia server-side com SSE-S3 (AES256) habilitada por padrão
- Policy que nega requisições sem aws:SecureTransport (obriga HTTPS)
- Versionamento configurável, padrão Enabled
- Tags obrigatórias aplicadas e mescladas com additional_tags

Tabela de variáveis
| Nome              | Tipo         | Obrigatória | Descrição |
|-------------------|--------------|-------------|-----------|
| environment       | string       | Sim         | Ambiente alvo. Deve ser dev, hml ou prd. |
| system            | string       | Sim         | Identificador do sistema, em minúsculas, números e hifens. |
| purpose           | string       | Sim         | Finalidade do bucket, em minúsculas, números e hifens. |
| region            | string       | Sim         | Região AWS para o provider (ex.: sa-east-1, us-east-1). |
| versioning_status | string       | Não         | Status do versionamento do bucket. Enabled (padrão) ou Suspended. |
| force_destroy     | bool         | Não         | Se true, permite destruir o bucket mesmo com objetos (use com cautela). Padrão: false. |
| additional_tags   | map(string)  | Não         | Tags adicionais a serem mescladas. Em conflito, as tags padrão prevalecem. |

Tabela de outputs
| Nome         | Descrição |
|--------------|-----------|
| bucket_name  | Nome do bucket S3. |
| bucket_arn   | ARN do bucket S3. |
| bucket_id    | ID do bucket S3. |

Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  purpose           = "logs"
  region            = "us-east-1"
  versioning_status = "Enabled"

  additional_tags = {
    Team = "platform"
  }
}
