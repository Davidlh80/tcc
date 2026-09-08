Nome
Blueprint Terraform para provisionar um bucket Amazon S3 seguro por padrão.

Descrição
Este template cria um bucket S3 com:
- Criptografia do lado do servidor habilitada por padrão (SSE-S3 AES256) ou SSE-KMS opcional.
- Bloqueio total de acesso público (Public Access Block).
- Ownership Controls com BucketOwnerEnforced (ACLs desabilitadas).
- Versionamento opcional (habilitado por padrão).
- Regra de ciclo de vida para abortar uploads multipart incompletos.
- Expiração opcional de versões não correntes e versões correntes.
- Política opcional para exigir transporte seguro (HTTPS).

Requisitos
- Terraform >= 1.5.0
- Provider AWS >= 5.32.0
- Credenciais AWS configuradas externamente (variáveis de ambiente, perfil, etc.)

Arquivos
- main.tf
- variables.tf
- outputs.tf
- versions.tf
- README.md

Como usar
1) Defina as credenciais e a região AWS no ambiente.
2) Ajuste as variáveis necessárias, principalmente bucket_name. Evite pontos no nome do bucket.
3) Opcionalmente, forneça kms_key_arn para usar SSE-KMS.
4) Se desejar habilitar logging (logging_enabled = true), forneça logging_target_bucket e garanta que o bucket de destino possua a política adequada para receber logs do S3.
5) Execute:
   - terraform init -backend=false
   - terraform validate
   - terraform plan
   - terraform apply

Variáveis principais
- aws_region: Região AWS. Padrão us-east-1.
- bucket_name: Nome globalmente único do bucket. Obrigatório.
- enable_versioning: Habilita versionamento. Padrão true.
- force_destroy: Permite destruir bucket com objetos. Padrão false.
- kms_key_arn: ARN da KMS Key para SSE-KMS. Vazio usa SSE-S3 (AES256).
- sse_kms_bucket_key_enabled: Habilita S3 Bucket Keys com SSE-KMS. Padrão true.
- logging_enabled: Habilita Server Access Logging. Padrão false.
- logging_target_bucket: Bucket alvo para logs. Necessário se logging_enabled = true.
- logging_target_prefix: Prefixo dos logs. Padrão s3-access-logs/.
- abort_incomplete_multipart_upload_days: Dias para abortar uploads incompletos. Padrão 7.
- noncurrent_version_expiration_days: Expiração de versões não correntes (0 desabilita). Padrão 0.
- current_version_expiration_days: Expiração de versões correntes (0 desabilita). Padrão 0.
- attach_secure_transport_policy: Exige HTTPS via política. Padrão true.
- tags: Tags adicionais a aplicar via default_tags do provider.

Outputs
- bucket_id: Nome do bucket.
- bucket_arn: ARN do bucket.
- bucket_regional_domain_name: Domínio regional do bucket.
- bucket_hosted_zone_id: Hosted zone ID para alias no Route53.
- encryption_algorithm: Algoritmo de criptografia em uso.
- kms_key_arn_in_use: ARN da KMS Key em uso, se houver.
- versioning_enabled: Indica se o versionamento está habilitado.

Notas e boas práticas
- O nome do bucket é globalmente único; escolha cuidadosamente.
- Evite usar pontos no nome do bucket para compatibilidade com HTTPS e certificados wildcard.
- Para Server Access Logging, o bucket de destino deve estar na mesma região e possuir política permitindo delivery de logs (você pode gerenciar isso separadamente).
- SSE-KMS oferece maior controle e auditoria, mas requer permissões adicionais no CMK.
- force_destroy = false por padrão para evitar perda acidental de dados.

Licença
Uso livre para fins educacionais e profissionais, sem garantias.
