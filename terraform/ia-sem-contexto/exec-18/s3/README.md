Blueprint Terraform: Amazon S3 Bucket

Descrição
- Provisiona um bucket S3 seguro por padrão:
  - Criptografia do lado do servidor habilitada (padrão aws:kms; usa a chave gerenciada AWS/S3 se nenhuma KMS for informada)
  - Bloqueio completo de acesso público (public access block)
  - Versionamento habilitado por padrão
  - Política opcional para negar tráfego sem TLS (habilitada por padrão)
  - Ownership Controls com BucketOwnerEnforced (ACLs desabilitadas)

Arquivos
- versions.tf: versões mínimas do Terraform e provider AWS; provider configurado com var.aws_region
- variables.tf: variáveis de entrada com validações
- main.tf: recursos S3 e configurações de segurança
- outputs.tf: saídas úteis do bucket
- README.md: instruções de uso

Pré-requisitos
- Terraform 1.4.0 ou superior
- Credenciais AWS válidas exportadas no ambiente (por exemplo, AWS_PROFILE ou variáveis AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY)
- Região padrão informada via var.aws_region (padrão us-east-1)

Variáveis principais
- bucket_name (obrigatória): nome globalmente único para o bucket
- aws_region (opcional): região AWS (padrão us-east-1)
- force_destroy (opcional): bool, destruir mesmo com objetos (padrão false)
- enable_versioning (opcional): bool, versionamento (padrão true)
- sse_algorithm (opcional): AES256 ou aws:kms (padrão aws:kms)
- kms_key_arn (opcional): ARN da chave KMS; se omitido com aws:kms, usa a chave gerenciada AWS/S3
- enable_tls_policy (opcional): bool, nega tráfego sem TLS (padrão true)
- tags (opcional): mapa de tags adicionais

Como usar (exemplo simples)
1) Defina as variáveis mínimas:
   - bucket_name = meu-bucket-unico-123

2) Inicialize e valide:
   - terraform init -backend=false
   - terraform validate

3) Planeje e aplique:
   - terraform plan -var "bucket_name=meu-bucket-unico-123"
   - terraform apply -var "bucket_name=meu-bucket-unico-123"

Observações
- A política de TLS nega qualquer operação ao bucket e objetos quando a conexão não usa HTTPS (aws:SecureTransport=false).
- Com BucketOwnerEnforced, ACLs são desabilitadas e o bucket usa o controle de propriedade do bucket.
- force_destroy=false protege contra deleção acidental de buckets com objetos; ajuste para true com cautela.
- Para usar uma chave KMS específica, forneça kms_key_arn e mantenha sse_algorithm=aws:kms.

Outputs
- bucket_name
- bucket_arn
- bucket_domain_name
- bucket_regional_domain_name
- versioning_status
- public_access_block_id
