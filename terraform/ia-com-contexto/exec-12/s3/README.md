Visão geral do recurso
- Este template provisiona um bucket Amazon S3 seguindo o padrão organizacional:
  - Nome no formato <ambiente>-<sistema>-s3-<finalidade>.
  - Bloqueio de acesso público com as quatro flags do Public Access Block.
  - Criptografia server-side habilitada por padrão com SSE-S3 (AES256), opcionalmente KMS.
  - Policy do bucket negando qualquer requisição sem aws:SecureTransport (somente HTTPS).
  - Versionamento configurável por variável, padrão Enabled.
  - Aplicação das tags obrigatórias e suporte a tags adicionais.

Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment (string) [obrigatória]: Ambiente do recurso (dev, hml, prd).
- system (string) [obrigatória]: Identificador do sistema/produto (ex.: tcc). Aceita [a-z0-9-].
- region (string) [obrigatória]: Região AWS (ex.: us-east-1).
- purpose (string) [obrigatória]: Finalidade do bucket (ex.: logs, artifacts, backups). Aceita [a-z0-9-].
- additional_tags (map(string)) [opcional]: Tags adicionais a aplicar (sobrescrevem chaves iguais).
- force_destroy (bool) [opcional]: Se true, permite destruir o bucket com objetos. Padrão: false.
- sse_algorithm (string) [opcional]: Algoritmo de criptografia SSE. Aceita: AES256, aws:kms. Padrão: AES256.
- kms_key_id (string) [opcional]: KMS Key ID/ARN quando sse_algorithm = aws:kms. Se omitido, usa a chave AWS gerenciada (aws/s3).
- versioning_status (string) [opcional]: Status do versionamento. Aceita: Enabled, Suspended. Padrão: Enabled.

Tabela de outputs (nome, descrição)
- bucket_name: Nome do bucket S3 criado.
- bucket_arn: ARN do bucket S3.
- bucket_id: ID do bucket (igual ao nome).

Exemplo de uso do módulo/recurso
- Exemplo mínimo:
  module "s3_bucket" {
    source      = "./"
    environment = "dev"
    system      = "tcc"
    region      = "us-east-1"
    purpose     = "logs"

    # Optionais:
    # versioning_status = "Enabled"
    # sse_algorithm     = "AES256"
    # kms_key_id        = null
    # force_destroy     = false
    # additional_tags = {
    #   Team = "platform"
    # }
  }
