Módulo Terraform — Bucket Amazon S3 seguro e padronizado

Descrição
- Cria um bucket S3 com:
  - bloqueio de acesso público;
  - criptografia server-side habilitada por padrão (AES256 ou KMS);
  - versionamento controlado por variável;
  - política que exige uso de TLS (HTTPS);
  - nomenclatura e tags alinhadas ao contexto organizacional.

Padrão de nomenclatura
- Nome do bucket: <ambiente>-<sistema>-s3-<finalidade>[-<sufixo-opcional>]
- Ex.: dev-tcc-s3-logs, prd-erp-s3-backups, hml-api-s3-artifacts-01
- Observação: nomes de bucket S3 são globais. Use name_suffix quando necessário para garantir unicidade e manter o total de caracteres ≤ 63.

Tags obrigatórias
Aplicadas automaticamente ao bucket (e passíveis de merge com additional_tags):
- Project     = "tcc-iac-ia"
- Environment = var.environment
- ManagedBy   = "terraform"
- Owner       = "devops"
- CostCenter  = "academic-research"

Variáveis
- aws_region (string, default: "us-east-1")
  Região AWS onde os recursos serão criados.

- environment (string, obrigatório; valores: dev, hml, prd)
  Ambiente alvo.

- system (string, obrigatório)
  Nome do sistema/aplicação. Apenas minúsculas, números e hífens.

- bucket_purpose (string, obrigatório)
  Finalidade do bucket. Apenas minúsculas, números e hífens. Ex.: logs, artifacts, backups.

- name_suffix (string, opcional)
  Sufixo auxiliar para unicidade global do nome do bucket. Apenas minúsculas, números e hífens.

- versioning_enabled (bool, default: true)
  Habilita versionamento do bucket.

- force_destroy (bool, default: false)
  Permite destruir o bucket mesmo contendo objetos. Use com cautela.

- sse_algorithm (string, default: "AES256"; valores: AES256, aws:kms)
  Algoritmo de criptografia server-side.

- kms_key_arn (string, default: "")
  ARN da KMS CMK quando sse_algorithm = "aws:kms". Obrigatório nesse caso.

- enable_bucket_key (bool, default: true)
  Habilita S3 Bucket Keys (efetivo somente com aws:kms).

- additional_tags (map(string), default: {})
  Tags adicionais a serem aplicadas (faz merge com as tags obrigatórias).

Outputs
- bucket_name: Nome do bucket criado.
- bucket_arn: ARN do bucket.
- bucket_id: ID do bucket (igual ao nome).

Exemplo de uso
module "s3_secure_bucket" {
  source = "./."

  aws_region        = "us-east-1"
  environment       = "dev"
  system            = "tcc"
  bucket_purpose    = "logs"
  name_suffix       = "01"
  versioning_enabled = true

  # Para KMS:
  # sse_algorithm  = "aws:kms"
  # kms_key_arn    = "arn:aws:kms:us-east-1:111122223333:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  # enable_bucket_key = true

  additional_tags = {
    DataClassification = "internal"
  }
}

Boas práticas e segurança
- Bloqueio de acesso público aplicado a nível de bucket.
- Política para negar qualquer operação sem TLS (aws:SecureTransport = false).
- Criptografia server-side habilitada por padrão (AES256) ou KMS conforme variável.
- Ownership control “BucketOwnerEnforced” para desabilitar ACLs e reduzir riscos de exposição involuntária.
- Versionamento habilitado por padrão para resiliência (pode ser desativado via variável).

Como validar
- terraform fmt
- terraform init -backend=false
- terraform validate

Observações
- Evite valores sensíveis hardcoded.
- Garanta que o nome final do bucket tenha ≤ 63 caracteres para atender às restrições do S3.
- Para uso com KMS, garanta que a chave KMS e permissões estejam configuradas adequadamente.
