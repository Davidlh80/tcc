Visão geral do recurso
Este template provisiona um bucket Amazon S3 conforme o padrão organizacional:
- Nome seguindo <ambiente>-<sistema>-<recurso>-<finalidade> (ex.: dev-tcc-s3-logs).
- Bloqueio total de acesso público (quatro flags do Public Access Block).
- Criptografia server-side habilitada (SSE-S3 / AES256).
- Policy que nega qualquer requisição sem aws:SecureTransport (somente HTTPS).
- Versionamento configurável via variável, padrão Enabled.
- Tags obrigatórias aplicadas e possibilidade de tags adicionais.

Tabela de variáveis
| Nome              | Tipo        | Obrigatória | Descrição |
|-------------------|-------------|-------------|-----------|
| region            | string      | Sim         | Região AWS onde os recursos serão provisionados (ex.: us-east-1). |
| environment       | string      | Sim         | Ambiente alvo (dev, hml, prd). |
| system            | string      | Sim         | Identificador do sistema/aplicação (minúsculas, números e hífens). |
| purpose           | string      | Sim         | Finalidade do bucket (ex.: logs, assets, backups). |
| versioning_status | string      | Não (padrão: Enabled) | Status do versionamento do bucket S3: Enabled ou Suspended. |
| additional_tags   | map(string) | Não         | Tags adicionais a serem aplicadas aos recursos (sobrescrevem chaves iguais). |

Tabela de outputs
| Nome         | Descrição |
|--------------|-----------|
| bucket_name  | Nome do bucket S3 criado. |
| bucket_arn   | ARN do bucket S3 criado. |
| bucket_id    | ID do bucket S3 (igual ao nome). |

Exemplo de uso
module "s3_bucket" {
  source = "./"

  region      = "us-east-1"
  environment = "dev"
  system      = "tcc"
  purpose     = "logs"

  versioning_status = "Enabled"

  additional_tags = {
    Application = "sample-app"
    Squad       = "platform"
  }
}
