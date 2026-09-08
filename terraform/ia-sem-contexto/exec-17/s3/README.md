Blueprint Terraform — Bucket Amazon S3

Descrição
- Cria um bucket S3 com padrões seguros:
  - Bloqueio total de acesso público (Public Access Block).
  - Propriedade de objetos forçada ao dono do bucket (BucketOwnerEnforced), sem ACLs.
  - Criptografia do lado do servidor (SSE) por padrão com AES256 ou KMS.
  - Versionamento opcional habilitado por padrão.
  - Política (opcional) para:
    - Exigir TLS (negar solicitações sem HTTPS).
    - Rejeitar uploads sem cabeçalho de criptografia apropriado (quando habilitado).

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS válidas exportadas no ambiente (somente para apply).

Arquivos
- main.tf: recursos AWS.
- variables.tf: entradas configuráveis com validações.
- outputs.tf: saídas úteis.
- versions.tf: versões mínimas do Terraform e providers.

Uso rápido
1) Ajuste variáveis necessárias (principalmente bucket_name). Exemplo de arquivo terraform.tfvars:
  bucket_name       = "meu-bucket-unico-123456"
  region            = "us-east-1"
  tags = {
    project = "demo"
    owner   = "devops"
  }

2) Inicialização e validação:
  terraform init -backend=false
  terraform validate
  terraform plan

3) Aplicação:
  terraform apply

Variáveis principais
- bucket_name (obrigatória): nome globalmente único (3–63 chars, [a-z0-9.-]).
- region: padrão us-east-1.
- enable_versioning: padrão true.
- sse_algorithm: "AES256" (padrão) ou "aws:kms".
- kms_key_id: obrigatório se sse_algorithm="aws:kms".
- require_encryption: se true (padrão), política nega PutObject sem cabeçalho de criptografia e com algoritmo diferente do configurado.
- attach_policy: se true (padrão), anexa política reforçando TLS e criptografia.
- force_destroy: se true, permite destruir bucket com objetos (padrão false).
- prevent_destroy: proteção contra destruição acidental (padrão true).
- tags: mapa de tags aplicadas.

Decisões de segurança
- Public Access Block habilitado.
- Ownership Controls: BucketOwnerEnforced (sem ACLs).
- Política de TLS: nega requisições sem HTTPS.
- Criptografia padrão aplicada no bucket. Quando require_encryption=true, uploads sem cabeçalho de criptografia adequado são negados; clientes devem enviar o cabeçalho s3:x-amz-server-side-encryption. Se usar KMS, informe kms_key_id (e o cliente deve enviar s3:x-amz-server-side-encryption-aws-kms-key-id ao fazer upload).

Observações
- O nome do bucket é globalmente único; escolha um nome que não exista.
- Por padrão, prevent_destroy=true. Para permitir terraform destroy, defina prevent_destroy=false e, se necessário, force_destroy=true.
- Este template não configura logging, website hosting ou políticas de acesso específicas por usuário/serviço.

Saídas
- bucket_name, bucket_arn, bucket_domain_name, bucket_regional_domain_name, sse_algorithm, versioning_enabled.

Licença
- Uso livre no contexto deste experimento.
