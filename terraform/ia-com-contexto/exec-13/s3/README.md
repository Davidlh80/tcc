1. Visão geral do recurso
Este template provisiona um bucket Amazon S3 seguindo o padrão corporativo:
- Nomenclatura: <environment>-<system>-s3-<purpose>
- Bloqueio total de acesso público (quatro flags do Public Access Block)
- Criptografia server-side padrão SSE-S3 (AES256)
- Bucket policy que nega requisições sem aws:SecureTransport (exige TLS)
- Versionamento configurável por variável (padrão Enabled)
- Tags corporativas obrigatórias aplicadas ao bucket

2. Tabela de variáveis
- environment (string) [Obrigatória]: Ambiente alvo. Valores permitidos: dev, hml, prd.
- system (string) [Obrigatória]: Identificador do sistema/aplicação (minúsculo, números e hífens).
- region (string) [Obrigatória]: Região AWS onde os recursos serão criados (ex.: us-east-1).
- additional_tags (map(string)) [Opcional]: Tags adicionais a serem aplicadas ao bucket.
- purpose (string) [Obrigatória]: Finalidade do bucket (minúsculo, números e hífens).
- versioning_status (string) [Opcional]: Status do versionamento. Valores: Enabled ou Suspended. Padrão: Enabled.
- force_destroy (bool) [Opcional]: Permite destruir o bucket mesmo com objetos. Padrão: false.

3. Tabela de outputs
- bucket_name: Nome do bucket S3 criado.
- bucket_arn: ARN do bucket S3.
- bucket_id: ID do bucket S3 (normalmente igual ao nome).

4. Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment      = "dev"
  system           = "tcc"
  region           = "us-east-1"
  purpose          = "logs"
  versioning_status = "Enabled"

  additional_tags = {
    Team = "platform"
  }
}
