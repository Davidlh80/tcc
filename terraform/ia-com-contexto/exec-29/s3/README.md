# Visão geral do recurso

Este template Terraform provisiona um bucket Amazon S3 seguindo as políticas internas de segurança e padronização:
- Nome do recurso: <environment>-<system>-s3-<purpose>;
- Bloqueio completo de acesso público (quatro flags do Public Access Block);
- Criptografia server-side habilitada com SSE-S3 (AES256);
- Policy que nega requisições sem aws:SecureTransport (obriga HTTPS);
- Versionamento configurável via variável, padrão Enabled;
- Tags obrigatórias aplicadas e possibilidade de tags adicionais.

# Tabela de variáveis

| Nome              | Tipo        | Obrigatória | Descrição |
|-------------------|-------------|-------------|-----------|
| environment       | string      | Sim         | Ambiente alvo do recurso. Valores permitidos: dev, hml, prd. |
| system            | string      | Sim         | Identificador do sistema/aplicação para compor o nome do recurso. |
| region            | string      | Sim         | Região AWS onde o bucket será criado (ex.: us-east-1). |
| purpose           | string      | Sim         | Finalidade do bucket para compor o nome do recurso (ex.: logs, assets, backups). |
| versioning_status | string      | Não         | Status do versionamento do bucket S3. Valores: Enabled, Suspended. Padrão: Enabled. |
| additional_tags   | map(string) | Não         | Tags adicionais a serem aplicadas. Tags obrigatórias sempre prevalecem. |

# Tabela de outputs

| Nome         | Descrição |
|--------------|-----------|
| bucket_name  | Nome do bucket S3 criado. |
| bucket_arn   | ARN do bucket S3 criado. |
| bucket_id    | ID do bucket S3 criado (igual ao nome do bucket). |

# Exemplo de uso

module "s3_bucket" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  purpose           = "logs"
  versioning_status = "Enabled"

  additional_tags = {
    Application = "example-app"
    Team        = "platform"
  }
}
