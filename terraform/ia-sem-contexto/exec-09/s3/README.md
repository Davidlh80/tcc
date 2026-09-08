# Terraform - Amazon S3 Bucket

Blueprint simples e segura por padrao para criar um bucket Amazon S3.

Principais caracteristicas:
- Criptografia server-side default (SSE-S3 AES256 por padrao ou KMS se informado).
- Bloqueio completo de acesso publico (ACLs e politicas).
- Versionamento habilitado por padrao.
- Regra de ciclo de vida opcional (abort multiparts, expira versoes antigas e opcionalmente objetos atuais).
- Politica que nega acessos sem TLS (https).

Requisitos:
- Terraform >= 1.3.0
- Provider AWS >= 4.67
- Credenciais AWS validas exportadas no ambiente ou via perfil

Uso rapido:
1. Defina as variaveis minimas (exemplo de terraform.tfvars):
   aws_region = "us-east-1"
   bucket_name = "meu-bucket-unico-global-123"

2. Inicialize e valide:
   terraform init -backend=false
   terraform validate

3. Planeje e aplique:
   terraform plan
   terraform apply

Variaveis principais:
- aws_region (string, obrigatoria): Regiao AWS.
- bucket_name (string, obrigatoria): Nome globalmente unico do bucket.
- force_destroy (bool, padrao: false): Destruir mesmo se houver objetos.
- versioning_enabled (bool, padrao: true): Ativa versionamento.
- enable_lifecycle_rules (bool, padrao: true): Cria regra padrao de ciclo de vida.
- lifecycle_abort_multipart_days (number, padrao: 7): Aborta uploads incompletos.
- lifecycle_noncurrent_version_expiration_days (number, padrao: 30): Expira versoes antigas.
- lifecycle_expiration_days (number|null, padrao: null): Expira objetos atuais (null desativa).
- logging_enabled (bool, padrao: false): Ativa Server Access Logging.
- logging_target_bucket (string|null, padrao: null): Bucket alvo para logs (exigido se logging_enabled = true).
- logging_target_prefix (string, padrao: "s3-access-logs/"): Prefixo para logs.
- kms_key_id (string|null, padrao: null): ARN/ID da CMK KMS; se nao informado, usa AES256.
- tags (map(string), padrao: {}): Tags adicionais.

Outputs:
- bucket_id: Nome do bucket.
- bucket_arn: ARN do bucket.
- bucket_domain_name: Endpoint global.
- bucket_regional_domain_name: Endpoint regional.
- versioning_status: Status do versionamento.
- public_access_block: Mapa com configuracoes de bloqueio publico.
- sse_algorithm: Algoritmo de criptografia efetivo.
- kms_key_id_effective: KMS Key ID/ARN efetivo (se houver).

Observacoes:
- bucket_name deve ser unico globalmente e seguir as regras do S3.
- Se ativar logging, garanta que o bucket de destino permita recebimento de logs do S3 (permissoes/ACLs apropriadas).
- Por padrao, todos os acessos sem TLS (http) sao negados pela politica do bucket.
- force_destroy permanece false por seguranca; altere conscientemente se precisar destruir um bucket com objetos.
