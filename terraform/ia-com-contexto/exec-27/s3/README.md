1. Visão geral do recurso
Este template provisiona um bucket Amazon S3 seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-s3-<purpose>
- Bloqueio completo de acesso público (quatro flags do Public Access Block)
- Criptografia server-side habilitada por padrão (SSE-S3 AES256), com opção de KMS
- Policy do bucket negando requisições sem TLS (aws:SecureTransport = false)
- Versionamento configurável por variável (padrão Enabled)
- Tags obrigatórias aplicadas e possibilidade de tags adicionais

2. Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome              | Tipo         | Obrigatória | Descrição                                                                 |
|-------------------|--------------|-------------|---------------------------------------------------------------------------|
| environment       | string       | Sim         | Ambiente da implantação (dev, hml, prd).                                  |
| system            | string       | Sim         | Nome do sistema, minúsculo com números e hífens (ex.: tcc).               |
| purpose           | string       | Sim         | Finalidade do bucket no padrão de nome (ex.: logs, data, assets).         |
| region            | string       | Sim         | Região AWS (ex.: us-east-1).                                              |
| versioning_status | string       | Não         | Status do versionamento (Enabled ou Suspended). Padrão: Enabled.          |
| sse_algorithm     | string       | Não         | Algoritmo SSE: AES256 (padrão) ou aws:kms.                                 |
| kms_key_id        | string/null  | Condicional | ARN/ID da CMK quando sse_algorithm=aws:kms. Obrigatório nestes casos.     |
| force_destroy     | bool         | Não         | Se true, permite destruir bucket não vazio. Padrão: false.                |
| additional_tags   | map(string)  | Não         | Tags adicionais sem sobrescrever as obrigatórias.                         |

3. Tabela de outputs (nome, descrição)
| Nome         | Descrição                         |
|--------------|-----------------------------------|
| bucket_name  | Nome do bucket S3 criado.         |
| bucket_arn   | ARN do bucket S3 criado.          |
| bucket_id    | ID do bucket (igual ao nome).     |

4. Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  purpose           = "logs"
  region            = "us-east-1"

  # Opcional: manter padrão AES256
  # sse_algorithm   = "AES256"

  # Exemplo com KMS:
  # sse_algorithm   = "aws:kms"
  # kms_key_id      = "arn:aws:kms:us-east-1:111122223333:key/abcd-1234-efgh-5678"

  # Versionamento (padrão Enabled)
  # versioning_status = "Enabled"

  # Não sobrescreva as chaves obrigatórias
  additional_tags = {
    Team = "platform"
  }

  # Destruição forçada (opcional)
  # force_destroy = false
}

Após aplicar, os recursos principais estarão disponíveis via outputs: bucket_name, bucket_arn e bucket_id.
