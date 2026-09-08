Nome
Blueprint Terraform para provisionar um bucket Amazon S3 com padrões seguros.

Descrição
Este template cria um bucket S3 com:
- Bloqueio total de acesso público (por padrão).
- Criptografia do lado do servidor (SSE-S3 AES256 por padrão, com opção de KMS).
- Versionamento habilitado (por padrão).
- Política opcional para exigir apenas conexões via TLS/SSL.
- Propriedade de objetos forçada para o dono do bucket (BucketOwnerEnforced), desabilitando ACLs.
- Tags padrão gerenciadas via provider e personalizáveis via variável.

Arquivos
- versions.tf: Restrições de versão do Terraform e providers.
- main.tf: Provider, recursos S3 e políticas.
- variables.tf: Variáveis de entrada com validações.
- outputs.tf: Saídas úteis.
- README.md: Instruções de uso.

Pré-requisitos
- Terraform >= 1.5.0
- Provider AWS >= 5.40.0
- Credenciais AWS válidas no ambiente (ex.: variáveis de ambiente, profile do AWS CLI, etc.)

Variáveis principais
- aws_region (string, padrão: us-east-1): Região AWS.
- aws_profile (string, opcional): Profile do AWS CLI.
- bucket_name (string, obrigatório): Nome único global do bucket (3-63 chars, minúsculas/números/hífens).
- environment (string, padrão: dev): Usada para tag Environment.
- tags (map(string), padrão: {}): Tags adicionais.
- enable_versioning (bool, padrão: true): Habilita versionamento.
- force_destroy (bool, padrão: false): Permite destruir bucket não vazio.
- block_public_access (bool, padrão: true): Bloqueia acesso público.
- sse_algorithm (string, padrão: AES256): AES256 ou aws:kms.
- kms_key_id (string, opcional): ID/ARN da KMS Key se usar aws:kms. Se omitido, usa a chave gerenciada pela AWS (alias/aws/s3).
- bucket_key_enabled (bool, padrão: true): Habilita S3 Bucket Keys quando usando KMS.
- attach_ssl_tls_policy (bool, padrão: true): Nega tráfego sem TLS via bucket policy.

Saídas
- bucket_id: ID do bucket.
- bucket_arn: ARN do bucket.
- bucket_name: Nome do bucket.
- bucket_domain_name: Domain name global.
- bucket_regional_domain_name: Domain name regional.
- region: Região AWS.
- versioning_enabled: Booleano do versionamento.
- encryption_algorithm: Algoritmo SSE aplicado.

Exemplo de uso
1) Ajuste as variáveis no terraform.tfvars (exemplo):
aws_region = "us-east-1"
bucket_name = "meu-bucket-exemplo-123"
environment = "dev"
tags = {
  Owner = "time-exemplo"
  Project = "projeto-x"
}

2) Comandos
- Formatar: terraform fmt
- Inicializar (sem backend remoto): terraform init -backend=false
- Validar: terraform validate
- Plano: terraform plan
- Aplicar: terraform apply

Notas
- Nome do bucket deve ser único globalmente.
- Para usar KMS gerenciada pelo cliente, defina sse_algorithm = "aws:kms" e informe kms_key_id (ARN/ID da chave).
- O bloqueio de acesso público é recomendado; desative apenas se souber exatamente o que está fazendo.
