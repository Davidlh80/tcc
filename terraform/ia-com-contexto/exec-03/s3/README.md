Visão geral do recurso
Este template cria um bucket Amazon S3 seguindo o padrão organizacional:
- Nome no formato: <environment>-<system>-s3-<purpose>
- Bloqueio de acesso público nas quatro flags do Public Access Block
- Criptografia server-side habilitada com SSE-S3 (AES256)
- Bucket policy para negar qualquer requisição sem aws:SecureTransport (somente HTTPS)
- Versionamento configurável por variável, padrão Enabled
- Tags obrigatórias aplicadas e possibilidade de tags adicionais

Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome               | Tipo         | Obrigatória | Descrição                                                                 |
|--------------------|--------------|-------------|---------------------------------------------------------------------------|
| environment        | string       | Sim         | Ambiente do recurso (dev, hml, prd).                                     |
| system             | string       | Sim         | Identificador do sistema, usado na composição do nome do bucket.         |
| purpose            | string       | Sim         | Finalidade do bucket (ex.: logs, assets, backups).                        |
| region             | string       | Sim         | Região AWS para provisionamento (ex.: us-east-1).                         |
| additional_tags    | map(string)  | Não         | Tags adicionais; as tags internas obrigatórias sempre prevalecem.         |
| versioning_enabled | bool         | Não         | Habilita versionamento do bucket (default: true -> Enabled).              |

Tabela de outputs (nome, descrição)
| Nome         | Descrição                      |
|--------------|--------------------------------|
| bucket_name  | Nome do bucket S3 criado.      |
| bucket_arn   | ARN do bucket S3.              |
| bucket_id    | ID do bucket S3.               |

Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment        = "dev"
  system             = "tcc"
  purpose            = "logs"
  region             = "us-east-1"
  versioning_enabled = true

  additional_tags = {
    Application = "sample-app"
    Team        = "platform"
  }
}

Outputs de exemplo:
- bucket_name: dev-tcc-s3-logs
- bucket_arn: arn:aws:s3:::dev-tcc-s3-logs
- bucket_id: dev-tcc-s3-logs
