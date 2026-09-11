Visão geral do recurso
- Este template provisiona um bucket Amazon S3 seguindo o padrão organizacional:
  - Nome no formato <environment>-<system>-s3-<purpose>;
  - Bloqueio total de acesso público (quatro flags do Public Access Block);
  - Criptografia server-side habilitada por padrão com SSE-S3 (AES256), opcionalmente KMS;
  - Policy que nega qualquer requisição sem aws:SecureTransport (exige HTTPS);
  - Versionamento configurável via variável, padrão Enabled;
  - Tags obrigatórias aplicadas a todos os recursos com suporte a tags.

Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment | string | sim | Ambiente alvo do recurso. Valores permitidos: dev, hml, prd.
- system | string | sim | Identificador do sistema/aplicação. Apenas [a-z0-9-], sem iniciar/terminar com hífen.
- purpose | string | sim | Finalidade do recurso (ex.: logs, assets, backups). Apenas [a-z0-9-].
- region | string | sim | Região AWS (ex.: us-east-1).
- versioning_status | string | não (padrão: Enabled) | Status do versionamento: Enabled ou Suspended.
- sse_algorithm | string | não (padrão: AES256) | Algoritmo de SSE: AES256 (SSE-S3) ou aws:kms.
- kms_key_id | string | condicional | ARN/ID da KMS Key quando sse_algorithm = aws:kms.
- force_destroy | bool | não (padrão: false) | Se true, permite destruir o bucket mesmo contendo objetos.
- additional_tags | map(string) | não (padrão: {}) | Tags adicionais mescladas às tags padrão.

Tabela de outputs (nome, descrição)
- bucket_name | Nome do bucket S3 criado.
- bucket_arn | ARN do bucket S3 criado.
- bucket_id | ID do bucket (igual ao nome).

Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  purpose           = "logs"
  region            = "us-east-1"

  # Opcional
  versioning_status = "Enabled"
  sse_algorithm     = "AES256"
  # Se usar KMS:
  # sse_algorithm = "aws:kms"
  # kms_key_id     = "arn:aws:kms:us-east-1:111122223333:key/abcd-ef01-2345-6789-abcdef012345"

  additional_tags = {
    Application = "my-app"
  }
}
