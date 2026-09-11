1. Visão geral do recurso
Este template provisiona um bucket Amazon S3 seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-s3-<purpose>
- Segurança:
  - Public Access Block com as quatro flags habilitadas
  - Criptografia server-side SSE-S3 (AES256) por padrão
  - Bucket Policy negando qualquer requisição sem aws:SecureTransport
  - Versionamento configurável por variável (padrão Enabled)
- Tags obrigatórias aplicadas e possibilidade de tags adicionais

2. Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment | string | sim | Ambiente do recurso. Valores permitidos: dev, hml, prd.
- system | string | sim | Identificador do sistema (apenas [a-z0-9-]).
- purpose | string | sim | Finalidade do recurso (apenas [a-z0-9-]).
- region | string | sim | Região AWS para criação (ex.: us-east-1).
- additional_tags | map(string) | não | Tags adicionais a serem mescladas às tags obrigatórias.
- versioning_status | string | não | Status do versionamento (Enabled ou Suspended). Padrão: Enabled.
- force_destroy | bool | não | Permite destruir o bucket mesmo contendo objetos. Padrão: false.

3. Tabela de outputs (nome, descrição)
- bucket_name | Nome do bucket S3 criado.
- bucket_arn | ARN do bucket S3 criado.
- bucket_id | ID do bucket S3 (normalmente igual ao nome).

4. Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment     = "dev"
  system          = "tcc"
  purpose         = "logs"
  region          = "us-east-1"
  versioning_status = "Enabled"

  additional_tags = {
    Team = "platform"
  }
}
