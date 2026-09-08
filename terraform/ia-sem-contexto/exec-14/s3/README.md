Blueprint Terraform — Amazon S3 Bucket

Descricao
- Provisiona um bucket S3 com configuracoes seguras por padrao:
  - Bloqueio de acesso publico (todas as opcoes habilitadas)
  - Criptografia em repouso (SSE-S3 por padrao, SSE-KMS opcional)
  - Versionamento (habilitado por padrao)
  - Politica para exigir TLS (negar trafego sem HTTPS)
  - Opcional: negar uploads sem SSE no cabecalho
  - Opcional: logging para bucket existente
  - Opcional: lifecycle para abortar uploads multipart incompletos

Arquivos
- main.tf: Recursos AWS S3 e politicas
- variables.tf: Variaveis configuraveis
- outputs.tf: Saidas relevantes
- versions.tf: Versoes de Terraform e provider
- README.md: Instrucoes de uso

Pre-requisitos
- Terraform >= 1.3.0
- Provider AWS ~> 5.x
- Credenciais AWS disponiveis via variaveis de ambiente, perfis ou outro metodo suportado pelo provider
- Nome de bucket globalmente unico

Uso basico
1) Configure as variaveis (exemplo em terraform.tfvars):
   bucket_name = "meu-bucket-unico-12345"
   aws_region  = "us-east-1"

2) Inicialize e valide:
   terraform init -backend=false
   terraform validate

3) (Opcional) Visualize o plano:
   terraform plan

4) Aplique:
   terraform apply

Variaveis principais
- bucket_name (obrigatoria): nome globalmente unico, minusculo, 3-63 chars.
- aws_region (padrao us-east-1)
- force_destroy (padrao false): permite destruir com objetos.
- enable_versioning (padrao true)
- kms_key_arn (opcional): ativa SSE-KMS quando definido.
- bucket_key_enabled (padrao true): relevante para SSE-KMS.
- enforce_sse (padrao true): nega PutObject sem cabecalho SSE ou com algoritmo incorreto.
- enforce_kms_key (padrao false): quando kms_key_arn definido, exige a mesma KMS key para uploads.
- enable_access_logging (padrao false), log_bucket_name (opcional), log_object_prefix (padrao s3-logs/).
- enable_lifecycle (padrao true), abort_incomplete_mpu_days (padrao 7).
- Public Access Block: block_public_acls, ignore_public_acls, block_public_policy, restrict_public_buckets (todos true por padrao).
- tags: mapa de tags.

Notas de seguranca e operacao
- Com enforce_sse = true, clientes devem enviar o cabecalho s3:x-amz-server-side-encryption com valor AES256 ou aws:kms (conforme configuracao). Caso contrario, o upload sera negado.
- Para usar SSE-KMS, defina kms_key_arn. Opcionalmente, habilite enforce_kms_key para forcar o uso exato dessa chave KMS.
- Server access logging requer que o bucket de destino exista e possua permissoes adequadas para receber logs do servico S3. Este template nao gerencia a politica do bucket de logs.
- force_destroy = true remove o bucket mesmo contendo objetos. Use com cautela.
- O nome do bucket deve ser unico globalmente; este template nao gera sufixos aleatorios.

Comandos uteis
- terraform init -backend=false
- terraform validate
- terraform plan -var="bucket_name=meu-bucket-unico-12345"
- terraform apply -var-file="terraform.tfvars"

Saidas
- bucket_name, bucket_arn, bucket_domain_name, bucket_regional_domain_name, hosted_zone_id
- versioning_status
- encryption_algorithm

Remocao
- terraform destroy
