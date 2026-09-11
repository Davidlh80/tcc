1. Visão geral do recurso
Este template provisiona um bucket Amazon S3 alinhado às políticas internas:
- Nome seguindo o padrão <ambiente>-<sistema>-<recurso>-<finalidade>, onde <recurso>=s3;
- Bloqueio completo de acesso público (quatro flags do Public Access Block);
- Criptografia server-side habilitada por padrão com SSE-S3 (AES256), com opção para KMS;
- Policy explícita negando qualquer requisição sem aws:SecureTransport (TLS);
- Versionamento configurável por variável, padrão Enabled;
- Tags obrigatórias aplicadas a todos os recursos que suportam tags.

2. Tabela de variáveis
- environment | string | Sim | Ambiente alvo: dev, hml ou prd.
- system | string | Sim | Identificador do sistema/produto (minusculo, sem espaços).
- region | string | Sim | Região AWS para o provider (ex.: us-east-1).
- purpose | string | Sim | Finalidade do bucket (compõe o nome).
- versioning_status | string | Não | Status do versionamento (Enabled ou Suspended). Padrão: Enabled.
- sse_algorithm | string | Não | Algoritmo SSE: AES256 (padrão) ou aws:kms.
- kms_key_arn | string | Condicional | ARN da chave KMS quando sse_algorithm=aws:kms.
- force_destroy | bool | Não | Força a destruição do bucket mesmo com objetos. Padrão: false.
- additional_tags | map(string) | Não | Tags adicionais mescladas às obrigatórias.

3. Tabela de outputs
- bucket_name | Nome do bucket S3 criado.
- bucket_arn | ARN do bucket S3 criado.
- bucket_id | ID do bucket S3 (mesmo que o nome).

4. Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "."

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  purpose           = "logs"
  versioning_status = "Enabled"
  sse_algorithm     = "AES256"

  # Quando usar KMS:
  # sse_algorithm = "aws:kms"
  # kms_key_arn   = "arn:aws:kms:us-east-1:111122223333:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  additional_tags = {
    Application = "sample-app"
  }
}
