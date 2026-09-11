Visão geral do recurso
Este template provisiona um bucket Amazon S3 seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-s3-<purpose>
- Segurança: bloqueio completo de acesso público (quatro flags), criptografia server-side AES256 (SSE-S3) por padrão e bucket policy negando qualquer requisição sem aws:SecureTransport (somente HTTPS).
- Governança: tags obrigatórias aplicadas e versionamento configurável (Enabled por padrão).

Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment (string) [obrigatória]: Ambiente alvo (dev, hml, prd).
- system (string) [obrigatória]: Nome do sistema/aplicação (minúsculo, sem espaços).
- region (string) [obrigatória]: Região AWS onde os recursos serão provisionados (ex.: us-east-1).
- additional_tags (map(string)) [opcional]: Tags adicionais a serem mescladas às tags padrão.
- purpose (string) [obrigatória]: Finalidade do bucket para composição do nome (ex.: logs, app, data).
- versioning_enabled (bool) [opcional]: Controla o versionamento do bucket (true = Enabled, false = Suspended). Padrão: true.
- force_destroy (bool) [opcional]: Permite destruir o bucket mesmo contendo objetos. Padrão: false.

Tabela de outputs (nome, descrição)
- bucket_name: Nome do bucket S3 criado.
- bucket_arn: ARN do bucket S3.
- bucket_id: ID do bucket S3 (normalmente igual ao nome).

Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  purpose           = "logs"
  versioning_enabled = true
  force_destroy     = false

  additional_tags = {
    Squad = "platform"
  }
}
