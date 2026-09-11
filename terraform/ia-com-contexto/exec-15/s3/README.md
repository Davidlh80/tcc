Visão geral do recurso
- Este template cria um bucket Amazon S3 seguindo as diretrizes organizacionais:
  - Nome no padrão <ambiente>-<sistema>-<recurso>-<finalidade> (com recurso = s3).
  - Bloqueio das quatro flags do Public Access Block.
  - Criptografia server-side habilitada por padrão (SSE-S3/AES256), com opção de KMS.
  - Bucket policy negando qualquer requisição sem aws:SecureTransport (somente HTTPS).
  - Versionamento configurável por variável (padrão Enabled).
  - Tags obrigatórias aplicadas, com suporte a tags adicionais sem sobrescrever as mandatórias.
  - Ownership Controls em BucketOwnerEnforced para eliminar ACLs.

Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment
  - tipo: string
  - obrigatória: sim (valores permitidos: dev, hml, prd)
  - descrição: Ambiente do recurso.
- system
  - tipo: string
  - obrigatória: sim
  - descrição: Identificador do sistema/produto, usado na composição do nome do recurso.
- region
  - tipo: string
  - obrigatória: sim
  - descrição: Região AWS do provider (ex.: us-east-1).
- additional_tags
  - tipo: map(string)
  - obrigatória: não (padrão: {})
  - descrição: Tags adicionais. As tags mandatórias não são sobrescritas.
- purpose
  - tipo: string
  - obrigatória: sim
  - descrição: Finalidade do bucket, usada na composição do nome (ex.: logs).
- versioning_status
  - tipo: string
  - obrigatória: não (padrão: Enabled)
  - descrição: Status do versionamento (Enabled ou Suspended).
- sse_algorithm
  - tipo: string
  - obrigatória: não (padrão: AES256)
  - descrição: Algoritmo de criptografia server-side (AES256 ou aws:kms).
- kms_key_id
  - tipo: string
  - obrigatória: condicional (obrigatório se sse_algorithm = aws:kms)
  - descrição: ARN/ID da CMK usada para SSE-KMS.
- force_destroy
  - tipo: bool
  - obrigatória: não (padrão: false)
  - descrição: Se true, permite destruir o bucket mesmo contendo objetos.

Tabela de outputs (nome, descrição)
- bucket_name
  - descrição: Nome do bucket S3 criado.
- bucket_arn
  - descrição: ARN do bucket S3 criado.
- bucket_id
  - descrição: ID do bucket S3 (igual ao nome).

Exemplo de uso do módulo/recurso
- Exemplo mínimo:
  module "s3_bucket" {
    source = "./"

    environment     = "dev"
    system          = "tcc"
    region          = "us-east-1"
    purpose         = "logs"
    versioning_status = "Enabled"

    # Opcional: criptografia com KMS
    # sse_algorithm = "aws:kms"
    # kms_key_id    = "arn:aws:kms:us-east-1:111122223333:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    additional_tags = {
      Team = "platform"
    }
  }

- O nome resultante do bucket seguirá o padrão: dev-tcc-s3-logs.
