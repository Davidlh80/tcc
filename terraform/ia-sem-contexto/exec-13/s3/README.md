Blueprint Terraform — Bucket Amazon S3

Descricao
- Provisiona um bucket S3 privado com boas praticas por padrao:
  - Bloqueio total de acesso publico (Public Access Block).
  - Ownership controls (BucketOwnerEnforced), desativando ACLs herdadas.
  - Criptografia SSE-S3 (AES256) por padrao.
  - Versionamento habilitado por padrao.
  - Politica que nega trafego sem TLS (HTTPS).
  - Regra de ciclo de vida para abortar uploads multiparte incompletos.

Arquivos
- versions.tf: restricoes de versao do Terraform e provider AWS.
- variables.tf: variaveis configuraveis.
- main.tf: recursos AWS.
- outputs.tf: saidas uteis.
- README.md: instrucoes.

Requisitos
- Terraform >= 1.4
- Provider AWS ~> 5.0
- Credenciais AWS configuradas no ambiente (perfil, variaveis de ambiente, etc.)

Variaveis principais
- bucket_name (string, obrigatorio): nome do bucket (3-63 chars, minusculas, numeros, ponto e hifen; inicia/termina com letra/numero).
- region (string, default: us-east-1): regiao AWS.
- force_destroy (bool, default: false): permite destruir o bucket com objetos.
- versioning_enabled (bool, default: true): habilita versionamento.
- object_lock_enabled (bool, default: false): requer versionamento; so na criacao.
- abort_multipart_upload_days (number, default: 7): aborta uploads multiparte incompletos.
- noncurrent_version_expiration_days (number, default: 365): expira versoes nao correntes (apenas se versionamento ativo).
- tags (map(string), default: {}): tags adicionais.

Saidas
- bucket_id: nome/ID do bucket.
- bucket_arn: ARN do bucket.
- bucket_domain_name: endpoint global.
- bucket_regional_domain_name: endpoint regional.
- hosted_zone_id: hosted zone do endpoint S3.
- versioning_status: Enabled ou Suspended.
- encryption_algorithm: algoritmo de criptografia aplicado (AES256).

Exemplo de uso
- Ajuste as variaveis (por exemplo, em terraform.tfvars):
  bucket_name = "meu-bucket-exemplo-123"
  region      = "us-east-1"
  tags = {
    Owner = "equipe-x"
    Env   = "dev"
  }

Comandos
- Inicializar: terraform init -backend=false
- Validar: terraform validate
- Planejar: terraform plan
- Aplicar: terraform apply
- Destruir: terraform destroy

Notas
- Por padrao, o bucket e privado e criptografado (SSE-S3).
- A politica nega acesso sem HTTPS.
- force_destroy permanece false para evitar remocoes acidentais; ajuste para true apenas quando necessario.
- Se precisar de SSE-KMS, substitua a configuracao de criptografia e forneca o KMS Key ID de forma segura (variavel).
