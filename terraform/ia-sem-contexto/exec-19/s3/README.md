Blueprint Terraform — Amazon S3 Bucket

Visao geral
Este template cria um bucket Amazon S3 com configuracoes seguras por padrao:
- Bloqueio total de acesso publico (Public Access Block).
- Propriedade do bucket para o dono (BucketOwnerEnforced), desabilitando ACLs.
- Criptografia padrao SSE-S3 (AES256) para todos os objetos.
- Versionamento habilitado por padrao (pode ser suspenso).
- Regras opcionais de ciclo de vida: abortar uploads multipart incompletos e expirar versoes nao correntes.
- Policy opcional para exigir conexoes TLS (HTTPS).

Requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS configuradas no ambiente (ex.: variaveis de ambiente ou perfil local)

Como usar (exemplo rapido)
1) Defina as variaveis principais (ex.: via -var):
   - bucket_name
   - aws_region (opcional, padrao us-east-1)

2) Comandos:
   terraform init -backend=false
   terraform plan -var="bucket_name=meu-bucket-exemplo-123" -var="aws_region=us-east-1"
   terraform apply -auto-approve -var="bucket_name=meu-bucket-exemplo-123" -var="aws_region=us-east-1"

Variaveis
- aws_region (string, default: us-east-1)
  Regiao AWS onde os recursos serao criados.
- bucket_name (string, obrigatorio)
  Nome globalmente unico do bucket S3; segue regras de nomenclatura do S3.
- force_destroy (bool, default: false)
  Permite destruir o bucket mesmo contendo objetos.
- enable_versioning (bool, default: true)
  Habilita ou suspende o versionamento.
- enable_lifecycle (bool, default: true)
  Controla a criacao das regras de ciclo de vida padrao.
- lifecycle_abort_incomplete_upload_days (number, default: 7)
  Aborta uploads multipart incompletos apos N dias.
- lifecycle_noncurrent_expiration_days (number, default: 30)
  Expira versoes nao correntes apos N dias.
- enforce_tls (bool, default: true)
  Se verdadeiro, aplica policy que nega trafego sem TLS.
- tags (map(string), default: {})
  Tags extras aplicadas via default_tags do provider (ManagedBy=terraform e Name no recurso sao adicionadas automaticamente).

Outputs
- bucket_id
- bucket_name
- bucket_arn
- bucket_domain_name
- bucket_regional_domain_name

Notas
- Este template nao configura backend remoto.
- Nenhuma credencial real e exigida para terraform validate; as credenciais sao necessarias apenas para aplicar.
- O nome do bucket deve ser unico globalmente na AWS.
