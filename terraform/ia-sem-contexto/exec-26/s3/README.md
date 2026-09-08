# Blueprint Terraform — Amazon S3 Bucket

Este template cria um bucket S3 com padroes de seguranca elevados:
- Bloqueio de acesso publico habilitado por padrao.
- Criptografia do lado do servidor (SSE-S3 AES256 por padrao, opcional KMS).
- Versionamento habilitado por padrao.
- Politica para negar trafego nao seguro (HTTP) por padrao.

Arquivos incluidos:
- main.tf
- variables.tf
- outputs.tf
- versions.tf

Requisitos:
- Terraform >= 1.4.0
- Provider AWS >= 5.0
- Credenciais AWS exportadas no ambiente (caso execute terraform apply)

Como usar (exemplo):
1) Ajuste as variaveis necessarias, principalmente bucket_name.
2) Comandos:
   - terraform init -backend=false
   - terraform validate
   - terraform plan -var 'bucket_name=meu-bucket-exemplo-123' -out=tfplan
   - terraform apply tfplan

Variaveis principais:
- bucket_name (obrigatoria): nome globalmente unico.
- aws_region (opcional): padrao us-east-1.
- enable_versioning (bool): padrao true.
- force_destroy (bool): padrao false.
- sse_algorithm (string): AES256 ou aws:kms. Padrao AES256.
- kms_key_id (string): obrigatoria quando sse_algorithm = aws:kms.
- bucket_key_enabled (bool): padrao true quando usar KMS.
- attach_deny_insecure_transport_policy (bool): padrao true.
- block_public_acls, block_public_policy, ignore_public_acls, restrict_public_buckets: todos padrao true.
- log_bucket_name (string): bucket existente para logs de acesso. Deixe vazio para desabilitar.
- log_prefix (string): padrao s3-access-logs/.
- tags (map(string)): tags padrao, inclui ManagedBy=Terraform.

Outputs:
- bucket_name
- bucket_arn
- region

Observacoes:
- O logging de acesso requer que o bucket de destino exista e permita recebimento de logs do S3.
- Quando usar KMS, informe kms_key_id (ARN ou ID/alias) acessivel ao S3 e ao chamador.
- Evite nomes de bucket ja utilizados globalmente.
