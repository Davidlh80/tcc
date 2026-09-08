Nome
- Blueprint Terraform para criar um bucket Amazon S3 seguro por padrão.

Recursos principais
- Bucket S3 com propriedade do objeto forçada ao dono (BucketOwnerEnforced).
- Bloqueio completo de acesso público.
- Versionamento opcional (habilitado por padrão).
- Criptografia em repouso habilitada por padrão (SSE-S3 AES256) ou KMS opcional.
- Política opcional para exigir HTTPS (negar requisições sem SecureTransport).
- Regra de ciclo de vida para abortar uploads multipart incompletos.

Arquivos
- versions.tf: versões do Terraform e providers.
- variables.tf: variáveis de entrada.
- main.tf: definição dos recursos.
- outputs.tf: saídas úteis.
- README.md: instruções de uso.

Pré-requisitos
- Terraform instalado.
- Credenciais AWS configuradas no ambiente (por exemplo, variáveis de ambiente).
- Nome de bucket globalmente único.

Como usar
1) Defina as variáveis desejadas (por exemplo via arquivo terraform.tfvars):
aws_region = "us-east-1"
bucket_name = "meu-bucket-unico-exemplo-123"

2) Inicialize e valide:
terraform init -backend=false
terraform validate

3) Visualize o plano e aplique:
terraform plan
terraform apply

Variáveis principais
- aws_region: Região AWS (padrão: us-east-1).
- bucket_name: Nome globalmente único do bucket (obrigatório).
- versioning_enabled: true/false para versionamento (padrão: true).
- force_destroy: true/false para destruir bucket com objetos (padrão: false).
- kms_key_id: ARN/ID da CMK para KMS; se omitida, usa SSE-S3.
- abort_incomplete_multipart_days: dias para abortar uploads incompletos (padrão: 7).
- attach_https_only_policy: anexa política que exige HTTPS (padrão: true).
- block_public_acls, block_public_policy, ignore_public_acls, restrict_public_buckets: controles de acesso público (padrão: true).
- tags: mapa de tags adicionais.

Saídas
- bucket_id, bucket_arn, bucket_name, bucket_regional_domain_name, versioning_status.

Notas
- O recurso usa configurações seguras por padrão (sem acesso público e com criptografia).
- Caso forneça kms_key_id, a criptografia usará aws:kms; caso contrário, AES256.
- A política HTTPS somente nega tráfego sem TLS e não torna o bucket público.

Comandos úteis
- terraform fmt
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply
