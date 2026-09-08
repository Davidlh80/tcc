Nome do projeto
Blueprint Terraform para criar um bucket Amazon S3 com padroes seguros.

Recursos implementados
- Bucket S3 com nome definido via variavel
- Ownership Controls com BucketOwnerEnforced (ACLs desabilitadas)
- Bloqueio de acesso publico (Public Access Block) habilitado por padrao
- Criptografia em repouso padrao (SSE-S3, AES256)
- Versionamento habilitavel (padrao: habilitado)
- Lifecycle:
  - Abort de uploads multipart incompletos (padrao: 7 dias)
  - Expiracao de versoes nao correntes (padrao: 90 dias; habilitada quando > 0 e versionamento ativo)
- Bucket Policy opcional para exigir TLS (HTTPS)

Requisitos
- Terraform >= 1.3.0
- Provider AWS ~> 5.0
- Credenciais AWS validas exportadas no ambiente (por exemplo, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_PROFILE) ou outro metodo suportado pelo provider
- Escolha um nome de bucket globalmente unico

Como usar
1) Defina as variaveis minimas necessarias (exemplo em terraform.tfvars):
  aws_region = "us-east-1"
  bucket_name = "meu-bucket-unico-123"

2) Comandos:
  terraform init -backend=false
  terraform validate
  terraform plan
  terraform apply

Variaveis principais
- aws_region (string): Regiao AWS. Padrao: us-east-1
- bucket_name (string): Nome globalmente unico do bucket. Obrigatorio
- force_destroy (bool): Permite destruir o bucket com objetos. Padrao: false
- versioning_enabled (bool): Ativa o versionamento. Padrao: true
- noncurrent_version_expiration_days (number): Expira versoes nao correntes apos N dias (0 para desabilitar). Padrao: 90
- abort_incomplete_multipart_upload_days (number): Aborta uploads incompletos apos N dias. Padrao: 7
- enable_public_access_block (bool): Bloqueia configuracoes publicas. Padrao: true
- attach_tls_enforce_policy (bool): Exige TLS via bucket policy. Padrao: true
- tags (map(string)): Tags adicionais. Padrao: {}

Outputs
- bucket_id: ID do bucket (igual ao nome)
- bucket_arn: ARN do bucket
- bucket_name: Nome do bucket
- bucket_domain_name: DNS global do bucket
- bucket_regional_domain_name: DNS regional do bucket
- bucket_hosted_zone_id: Hosted Zone ID do endpoint regional do S3
- region: Regiao AWS utilizada

Notas
- O nome do bucket deve ser globalmente unico em toda a AWS.
- Ownership Controls com BucketOwnerEnforced desabilita ACLs no bucket e objetos, o que e recomendado para minimizar configuracoes de acesso legado.
- A policy de TLS nega qualquer acesso nao-HTTPS. Caso tenha necessidades especificas (por exemplo, testes locais), desabilite com attach_tls_enforce_policy = false.
- Este template nao configura backend remoto do Terraform.
