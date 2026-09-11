1. Visão geral do recurso
- Este template provisiona um bucket Amazon S3 com:
  - Nome seguindo o padrão <environment>-<system>-s3-<purpose>;
  - Public Access Block nas quatro flags habilitadas;
  - Criptografia server-side padrão SSE-S3 (AES256);
  - Bucket policy negando requisições sem aws:SecureTransport;
  - Versionamento configurável por variável (padrão Enabled);
  - Tags corporativas obrigatórias aplicadas, com suporte a tags adicionais.

2. Tabela de variáveis (nome, tipo, obrigatória, descrição)
- region | string | sim | Região AWS para criação dos recursos (ex.: us-east-1).
- environment | string | sim | Ambiente permitido: dev, hml ou prd.
- system | string | sim | Identificador do sistema (minúsculo, números e hífens).
- purpose | string | sim | Finalidade do bucket para compor o nome (minúsculo, números e hífens).
- versioning_enabled | bool | não (padrão: true) | Habilita (true) ou suspende (false) o versionamento do bucket.
- force_destroy | bool | não (padrão: false) | Permite destruir o bucket mesmo contendo objetos.
- additional_tags | map(string) | não (padrão: {}) | Tags extras a serem mescladas às tags obrigatórias.

3. Tabela de outputs (nome, descrição)
- bucket_name | Nome do bucket S3 criado.
- bucket_arn | ARN do bucket S3.
- bucket_id | ID do bucket S3 (geralmente igual ao nome).

4. Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  region            = "us-east-1"
  environment       = "dev"
  system            = "tcc"
  purpose           = "logs"
  versioning_enabled = true

  additional_tags = {
    Team = "platform"
  }
}
