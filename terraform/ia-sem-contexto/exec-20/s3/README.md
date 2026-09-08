Nome
- Blueprint Terraform para criar um bucket Amazon S3 seguro por padrao.

Recursos provisionados
- Bucket S3 com:
  - Criptografia em repouso por padrao (AES256 ou AWS KMS).
  - Bloqueio de acesso publico (todas as opcoes ativadas por padrao).
  - Versionamento habilitado por padrao.
  - Regra de Lifecycle para abortar uploads multipart incompletos.
  - Opcional: expiracao de versoes nao correntes.
  - Politica para negar trafego nao criptografado (sem TLS).
  - Opcional: politica que exige header de SSE nos uploads.

Uso basico
- Defina as variaveis minimas e aplique:
  - Crie um arquivo terraform.tfvars (ou passe via -var):
    aws_region = "us-east-1"
    bucket_name = "meu-bucket-unico-globalmente"
- Comandos:
  - terraform init -backend=false
  - terraform validate
  - terraform plan
  - terraform apply

Atencao sobre enforce_sse_in_put_policy
- Quando enforce_sse_in_put_policy = true, clientes precisam enviar o header s3:x-amz-server-side-encryption:
  - "AES256" se sse_algorithm = "AES256".
  - "aws:kms" se sse_algorithm = "aws:kms".
- Se nao enviarem o header, os uploads serao negados mesmo com criptografia padrao do bucket.

Variaveis principais
- aws_region (string): Regiao AWS. Padrao: us-east-1.
- bucket_name (string): Nome globalmente unico do bucket. Obrigatorio.
- versioning_enabled (bool): Habilita versionamento. Padrao: true.
- force_destroy (bool): Permite destruir bucket com objetos. Padrao: false.
- sse_algorithm (string): "AES256" ou "aws:kms". Padrao: "AES256".
- sse_kms_key_arn (string|null): ARN da chave KMS (opcional; use com aws:kms).
- enforce_sse_in_put_policy (bool): Exige header SSE nos PUTs. Padrao: false.
- abort_incomplete_multipart_upload_days (number): Dias para abortar uploads incompletos. Padrao: 7.
- noncurrent_version_expiration_days (number): Dias para expirar versoes nao correntes (0 desabilita). Padrao: 90.
- object_ownership (string): "BucketOwnerEnforced" por padrao.
- block_public_acls, block_public_policy, ignore_public_acls, restrict_public_buckets (bool): Controles de acesso publico. Padrao: true.
- tags (map(string)): Tags adicionais. Padrao: {}.

Outputs
- bucket_id: Nome do bucket.
- bucket_arn: ARN do bucket.
- bucket_domain_name: Domain name do bucket.
- bucket_regional_domain_name: Domain name regional do bucket.
- bucket_region: Regiao do bucket.
- versioning_status: Status do versionamento.
- sse_algorithm: Algoritmo de criptografia definido.

Requisitos
- Terraform >= 1.5.0.
- Provider AWS ~> 5.x.
- Credenciais AWS adequadas configuradas no ambiente para aplicar (nao necessarias para terraform validate).
