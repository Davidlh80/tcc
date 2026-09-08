Blueprint Terraform para criação de um bucket Amazon S3 com configurações seguras por padrão.

Recursos provisionados:
- Bucket S3 com tags
- Controle de propriedade (BucketOwnerEnforced) para desativar ACLs
- Bloqueio de acesso público (todas as flags ativadas por padrão)
- Versionamento (habilitado por padrão)
- Criptografia do lado do servidor (SSE-S3 AES256 por padrão, opcional KMS)
- Política que nega acesso sem TLS
- Regras de ciclo de vida (abortar multipart após X dias, expirar versões não correntes e delete markers órfãos)

Pré-requisitos:
- Terraform 1.3+ instalado
- Provider AWS ~> 5.x
- Credenciais AWS válidas exportadas no ambiente (por exemplo, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY) ou usando perfil do AWS CLI
- Escolher uma região AWS e um nome de bucket globalmente único

Como usar:
1) Ajuste variáveis conforme necessário (por exemplo, em terraform.tfvars):
region = "us-east-1"
bucket_name = "meu-bucket-unico-global-123"
tags = {
  ambiente = "dev"
  projeto  = "exemplo"
}

2) Inicialize e valide:
terraform init -backend=false
terraform validate

3) Visualize o plano:
terraform plan

4) Aplique:
terraform apply

Principais variáveis:
- region (string, default: us-east-1): Região AWS.
- bucket_name (string, obrigatório): Nome globalmente único do bucket.
- force_destroy (bool, default: false): Se true, destrói o bucket com objetos.
- enable_versioning (bool, default: true): Habilita versionamento.
- sse_algorithm (string, default: AES256): AES256 ou aws:kms.
- kms_key_id (string, default: null): ID/ARN da chave KMS (se usar aws:kms, opcional).
- abort_incomplete_multipart_days (number, default: 7): Aborta uploads multipart incompletos após X dias.
- noncurrent_version_expiration_days (number, default: 90): Expira versões não correntes após X dias (0 para desabilitar).
- expire_delete_markers (bool, default: true): Remove delete markers órfãos.
- block_public_acls, block_public_policy, ignore_public_acls, restrict_public_buckets (bools, default: true): Controles de acesso público.
- tags (map(string), default: {}): Tags adicionais.

Outputs:
- bucket_id: Nome/ID do bucket.
- bucket_arn: ARN do bucket.
- bucket_domain_name: Endpoint global do bucket.
- bucket_regional_domain_name: Endpoint regional do bucket.
- versioning_status: Status do versionamento.
- sse_algorithm: Algoritmo de criptografia aplicado.

Notas:
- O nome do bucket deve ser globalmente único na AWS.
- Por padrão, o acesso público é bloqueado e o tráfego sem TLS é negado.
- Para usar KMS gerenciado pelo cliente, defina sse_algorithm = "aws:kms" e opcionalmente kms_key_id com a CMK desejada; se kms_key_id não for informado, a chave gerenciada pela AWS para S3 será usada.
