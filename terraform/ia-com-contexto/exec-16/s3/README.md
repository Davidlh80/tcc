Visão geral do recurso
- Este template provisiona um bucket Amazon S3 seguindo o padrão organizacional:
  - Nomenclatura: <environment>-<system>-s3-<purpose>
  - Segurança: bloqueio total de acesso público (quatro flags), criptografia SSE-S3 (AES256), e bucket policy negando requisições sem aws:SecureTransport.
  - Governança: tags obrigatórias aplicadas e versionamento configurável (padrão Enabled).

Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment (string, obrigatório): Ambiente alvo. Valores permitidos: dev, hml, prd.
- system (string, obrigatório): Nome do sistema (minúsculas, dígitos e hífens). Ex.: tcc.
- region (string, obrigatório): Região AWS para criação dos recursos. Ex.: us-east-1.
- purpose (string, obrigatório): Finalidade do bucket (minúsculas, dígitos e hífens). Ex.: logs, assets, backups.
- additional_tags (map(string), opcional): Tags adicionais a serem aplicadas aos recursos. Padrão: {}.
- versioning_status (string, opcional): Status do versionamento do bucket. Valores: Enabled, Suspended. Padrão: Enabled.
- sse_algorithm (string, opcional): Algoritmo de criptografia SSE. Conforme política, apenas AES256 é aceito. Padrão: AES256.
- force_destroy (bool, opcional): Se true, permite destruir o bucket mesmo contendo objetos. Padrão: false.

Tabela de outputs (nome, descrição)
- bucket_name: Nome do bucket S3 criado.
- bucket_arn: ARN do bucket S3.
- bucket_id: ID do bucket S3 (normalmente igual ao nome).

Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment      = "dev"
  system           = "tcc"
  region           = "us-east-1"
  purpose          = "logs"
  versioning_status = "Enabled"

  # Opcional
  additional_tags = {
    Team = "platform"
  }
  force_destroy  = false
  sse_algorithm  = "AES256"
}
