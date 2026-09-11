Visão geral do recurso
- Este template provisiona um bucket Amazon S3 conforme a política interna:
  - Nome no padrão <environment>-<system>-s3-<purpose>;
  - Bloqueio completo de acesso público (quatro flags do Public Access Block);
  - Criptografia server-side habilitada com SSE-S3 (AES256);
  - Política que nega requisições sem aws:SecureTransport (HTTPS obrigatório);
  - Versionamento configurável por variável, com padrão Enabled;
  - Tags obrigatórias aplicadas, com suporte a tags adicionais.

Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment | string | Sim | Ambiente do recurso. Valores permitidos: dev, hml, prd.
- system | string | Sim | Nome do sistema/aplicação (minúsculo, números e hífens).
- region | string | Sim | Região AWS para o provisionamento (ex.: us-east-1).
- purpose | string | Sim | Finalidade do bucket seguindo a convenção de nomes (ex.: logs, assets, backups).
- versioning_enabled | bool | Não | Habilita versionamento do bucket S3 (padrão: true => Enabled).
- additional_tags | map(string) | Não | Tags adicionais a serem mescladas às tags obrigatórias.

Tabela de outputs (nome, descrição)
- bucket_name | Nome do bucket S3.
- bucket_arn | ARN do bucket S3.
- bucket_id | ID do bucket S3.

Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source  = "./"
  region  = "us-east-1"

  environment = "dev"
  system      = "tcc"
  purpose     = "logs"

  versioning_enabled = true

  additional_tags = {
    Squad = "payments"
  }
}
