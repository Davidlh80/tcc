1. Visão geral do recurso
Este template provisiona um bucket Amazon S3 seguindo o padrão organizacional:
- Nome: <environment>-<system>-s3-<purpose>
- Segurança:
  - Public Access Block com as quatro flags habilitadas;
  - Criptografia server-side padrão SSE-S3 (AES256);
  - Bucket Policy negando qualquer requisição sem aws:SecureTransport (somente TLS);
  - Ownership Controls com BucketOwnerEnforced (sem ACLs);
  - Versionamento configurável, padrão Enabled.
- Governança:
  - Tags obrigatórias aplicadas a todos os recursos que suportam tags;
  - Variáveis validadas e outputs padronizados.

2. Tabela de variáveis
| Nome              | Tipo         | Obrigatória | Descrição                                                                 |
|-------------------|--------------|-------------|-----------------------------------------------------------------------------|
| environment       | string       | Sim         | Ambiente do recurso. Valores permitidos: dev, hml, prd.                    |
| system            | string       | Sim         | Identificador do sistema/aplicação (minúsculo, números e hífens).          |
| purpose           | string       | Sim         | Finalidade do recurso (ex.: logs, assets, backups).                         |
| region            | string       | Sim         | Região AWS (ex.: us-east-1).                                               |
| additional_tags   | map(string)  | Não         | Tags adicionais. Em conflitos, as tags obrigatórias prevalecem.            |
| versioning_status | string       | Não         | Status do versionamento do bucket (Enabled ou Suspended). Padrão: Enabled. |
| force_destroy     | bool         | Não         | Força a destruição do bucket mesmo se não estiver vazio. Padrão: false.    |

3. Tabela de outputs
| Nome         | Descrição                                            |
|--------------|------------------------------------------------------|
| bucket_name  | Nome do bucket S3 criado.                            |
| bucket_arn   | ARN do bucket S3.                                    |
| bucket_id    | ID do bucket S3 (normalmente igual ao nome).         |

4. Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  purpose     = "logs"
  region      = "us-east-1"

  additional_tags = {
    Team = "platform"
  }

  # versioning_status = "Enabled"  # padrão
  # force_destroy     = false      # padrão
}
