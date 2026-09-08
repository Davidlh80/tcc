Nome
Blueprint Terraform: Amazon S3 Bucket seguro por padrão

Descrição
Este template cria um bucket Amazon S3 com:
- Criptografia do lado do servidor habilitada por padrão (AES256 por padrão, opcional KMS).
- Bloqueio de acesso público (todas as opções em true por padrão).
- Versionamento habilitado por padrão.
- Política que nega acessos sem TLS (HTTPS) opcionalmente habilitada.

Arquivos
- main.tf: recursos AWS S3 e política.
- variables.tf: variáveis configuráveis.
- outputs.tf: saídas úteis.
- versions.tf: requisitos de versão do Terraform e provider.
- README.md: instruções de uso.

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS configuradas no ambiente (para aplicar). Para validar sintaxe, não são necessárias.

Uso rápido
1) Configure as variáveis mínimas (o nome do bucket é obrigatório e deve ser globalmente único na AWS):
- Exemplo de valores:
  - region = "us-east-1"
  - bucket_name = "meu-bucket-unico-123456"

2) Comandos sugeridos:
- Formatar: terraform fmt
- Inicializar (sem backend remoto): terraform init -backend=false
- Validar: terraform validate
- Aplicar (exemplo):
  terraform apply \
    -var="region=us-east-1" \
    -var="bucket_name=meu-bucket-unico-123456"

Variáveis principais
- region (string, default: "us-east-1"): Região onde criar o bucket.
- bucket_name (string, obrigatório): Nome globalmente único para o bucket.
- enable_versioning (bool, default: true): Habilita versionamento.
- force_destroy (bool, default: false): Permite destruir o bucket com objetos.
- sse_algorithm (string, default: "AES256"): "AES256" ou "aws:kms".
- kms_key_id (string, default: null): Requerido se sse_algorithm="aws:kms" (ID ou ARN da chave).
- enable_bucket_key (bool, default: true): Otimização de custo KMS (Bucket Key).
- attach_tls_policy (bool, default: true): Anexa política que nega requisições sem TLS.
- block_public_acls, ignore_public_acls, block_public_policy, restrict_public_buckets (bools, default: true): Controles de acesso público.
- tags (map(string), default: {}): Tags adicionais.

Notas de segurança
- Este template é seguro por padrão: bloqueia acesso público, força criptografia e pode negar tráfego sem TLS.
- Se optar por sse_algorithm="aws:kms", informe kms_key_id correspondente à chave KMS permitida para o bucket.
- OwnershipControls está em "BucketOwnerEnforced", portanto ACLs são desabilitadas.

Saídas
- bucket_id, bucket_arn, bucket_name
- bucket_domain_name, bucket_regional_domain_name
- region
- versioning_status
- sse_algorithm
- bucket_policy_id (se a política TLS for criada)

Limitações e decisões
- Não há backend remoto configurado, permitindo init -backend=false.
- Validações de nome do bucket cobrem regras básicas de nomenclatura.
- A validação cruzada entre sse_algorithm e kms_key_id não é aplicada via schema; se usar KMS, forneça kms_key_id.

Destruição
- Caso tenha objetos versionados, force_destroy=true permite remoção do bucket. Use com cautela.

Licença
Uso livre como exemplo de referência.
