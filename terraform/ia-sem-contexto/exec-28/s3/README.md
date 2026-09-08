Visão geral
- Este template Terraform cria um bucket Amazon S3 com padrões seguros:
  - Bloqueio completo de acesso público (Public Access Block).
  - Propriedade de objetos pelo dono do bucket (BucketOwnerEnforced).
  - Criptografia em repouso por padrão (SSE-S3 AES256) ou SSE-KMS quando fornecido um KMS Key ARN.
  - Versionamento habilitado por padrão.
  - Política que nega acesso sem TLS (opcional, habilitado por padrão).
  - Regra de ciclo de vida para abortar uploads multipart incompletos (habilitada por padrão).

Arquivos
- versions.tf: versões mínimas do Terraform e provider AWS.
- main.tf: recursos AWS S3 e políticas.
- variables.tf: variáveis de entrada com validações.
- outputs.tf: saídas úteis do bucket.
- README.md: instruções de uso.

Pré-requisitos
- Terraform 1.3+.
- Credenciais AWS válidas configuradas no ambiente (ex.: variáveis AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN ou mecanismo equivalente do provider).
- Definir um nome de bucket globalmente único.

Como usar
1) Inicialize
- terraform init -backend=false

2) Visualize o plano
- terraform plan -var 'bucket_name=<nome-unico-global>'

3) Aplique
- terraform apply -var 'bucket_name=<nome-unico-global>'

4) Destrua (atenção)
- terraform destroy -var 'bucket_name=<nome-unico-global>'

Variáveis principais
- aws_region (string, default: us-east-1)
  Região onde os recursos serão criados.

- bucket_name (string, obrigatório)
  Nome globalmente único do bucket S3. Deve seguir as regras de nomenclatura S3.

- versioning_enabled (bool, default: true)
  Habilita ou suspende o versionamento.

- force_destroy (bool, default: false)
  Permite destruir o bucket mesmo com objetos (use com cautela).

- kms_key_arn (string, default: null)
  ARN da chave KMS. Se definido, usa SSE-KMS (aws:kms) com Bucket Key habilitado; caso contrário, usa SSE-S3 (AES256).

- lifecycle_abort_incomplete_multipart_upload_days (number, default: 7)
  Aborta uploads multipart incompletos após N dias. Defina 0 para desabilitar.

- enforce_tls_only (bool, default: true)
  Cria política que nega requisições sem TLS (aws:SecureTransport=false).

- tags (map(string), default: {})
  Tags adicionais; a tag ManagedBy=Terraform é aplicada automaticamente.

Outputs
- bucket_id: nome do bucket.
- bucket_arn: ARN do bucket.
- bucket_domain_name: endpoint público.
- bucket_regional_domain_name: endpoint regional.
- versioning_status: Enabled ou Suspended.
- encryption_algorithm: AES256 ou aws:kms.
- kms_key_arn_in_use: ARN da chave KMS, se usado.
- region: região do provider.

Notas de segurança
- O acesso público está bloqueado por padrão.
- A política TLS-only ajuda a evitar tráfego sem criptografia em trânsito.
- A criptografia em repouso é aplicada a todos os objetos por padrão.
- Se usar KMS, garanta permissões adequadas na chave para serviços/usuários que farão upload/consulta de objetos.

Limitações
- O nome do bucket deve ser único em toda a AWS.
- Este template não configura logging de acesso; se necessário, habilite em uma iteração futura com um bucket de logs dedicado e respectivas permissões.
