Visão geral do recurso
Este template provisiona um bucket Amazon S3 seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-s3-<purpose>
- Public Access Block: todas as quatro flags ativadas
- Criptografia em repouso: SSE-S3 (AES256) habilitada por configuração do bucket
- Policy de segurança: nega qualquer requisição sem aws:SecureTransport (exige TLS)
- Versionamento: controlado por variável, padrão Enabled
- Tags: aplica as tags obrigatórias da organização e permite tags adicionais

Tabela de variáveis
| Nome              | Tipo        | Obrigatória | Descrição                                                                 |
|-------------------|-------------|-------------|---------------------------------------------------------------------------|
| environment       | string      | Sim         | Ambiente de deploy. Valores permitidos: dev, hml, prd.                    |
| system            | string      | Sim         | Identificador do sistema/produto. Somente [a-z0-9-].                       |
| purpose           | string      | Sim         | Finalidade do bucket (ex.: logs, assets, backups). Somente [a-z0-9-].      |
| region            | string      | Sim         | Região AWS (ex.: us-east-1).                                              |
| additional_tags   | map(string) | Não         | Tags adicionais aplicadas aos recursos com suporte a tags.                |
| versioning_status | string      | Não         | Status do versionamento: Enabled (padrão) ou Suspended.                   |

Tabela de outputs
| Nome         | Descrição                          |
|--------------|------------------------------------|
| bucket_name  | Nome do bucket S3 criado.          |
| bucket_arn   | ARN do bucket S3.                  |
| bucket_id    | ID do bucket S3 (igual ao nome).   |

Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  purpose           = "logs"
  region            = "us-east-1"
  versioning_status = "Enabled"

  additional_tags = {
    OwnerEmail = "squad-tcc@example.com"
  }
}
