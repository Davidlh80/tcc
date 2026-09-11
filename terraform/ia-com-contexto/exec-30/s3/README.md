1. Visão geral do recurso
Este template cria um bucket Amazon S3 seguindo o padrão organizacional:
- Nome no formato <ambiente>-<sistema>-<recurso>-<finalidade>, onde recurso=s3.
- Bloqueio total de acesso público via Public Access Block (todas as quatro flags).
- Criptografia server-side habilitada por padrão com SSE-S3 (AES256), com opção de usar KMS.
- Bucket policy que nega qualquer requisição sem aws:SecureTransport (HTTPS obrigatório).
- Versionamento configurável por variável (padrão Enabled).
- Aplicação das tags obrigatórias e suporte a tags adicionais sem sobrescrever as obrigatórias.

2. Tabela de variáveis
| Nome              | Tipo        | Obrigatória | Descrição |
|-------------------|-------------|-------------|-----------|
| environment       | string      | Sim         | Ambiente do recurso. Valores permitidos: dev, hml, prd. |
| system            | string      | Sim         | Nome do sistema/aplicação (minúsculo, números e hífens). |
| region            | string      | Sim         | Região AWS (ex.: us-east-1). |
| purpose           | string      | Sim         | Finalidade do recurso; compõe o nome do bucket. |
| versioning_status | string      | Não         | Status do versionamento do bucket. Valores: Enabled, Suspended. Padrão: Enabled. |
| sse_algorithm     | string      | Não         | Algoritmo de criptografia SSE. Valores: AES256, aws:kms. Padrão: AES256. |
| kms_key_id        | string/null | Condicional | ARN/ID da KMS Key quando sse_algorithm=aws:kms. Obrigatório apenas neste caso. |
| additional_tags   | map(string) | Não         | Tags adicionais a aplicar. As tags obrigatórias sempre prevalecem. |

3. Tabela de outputs
| Nome         | Descrição |
|--------------|-----------|
| bucket_name  | Nome do bucket S3 criado. |
| bucket_arn   | ARN do bucket S3 criado. |
| bucket_id    | ID do bucket S3 (igual ao nome). |

4. Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "logs"

  # opcionais
  versioning_status = "Enabled"
  sse_algorithm     = "AES256"

  additional_tags = {
    Team = "platform"
  }
}

# Exemplo usando KMS:
# module "s3_bucket_kms" {
#   source          = "./"
#   environment     = "prd"
#   system          = "tcc"
#   region          = "us-east-1"
#   purpose         = "data"
#   sse_algorithm   = "aws:kms"
#   kms_key_id      = "arn:aws:kms:us-east-1:111122223333:key/abcd-1234-efgh-5678"
#   additional_tags = {}
# }
