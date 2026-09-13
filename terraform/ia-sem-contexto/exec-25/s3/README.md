# Blueprint Terraform: Bucket S3

Blueprint para provisionamento de um bucket Amazon S3 seguro por padrao, sem vinculo a padroes organizacionais especificos.

## Recursos criados

- `aws_s3_bucket`: bucket S3 principal.
- `aws_s3_bucket_ownership_controls`: forca `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block`: bloqueia todo acesso publico (ACLs e politicas).
- `aws_s3_bucket_versioning`: versionamento de objetos configuravel.
- `aws_s3_bucket_server_side_encryption_configuration`: criptografia server-side (AES256 por padrao ou SSE-KMS se uma chave for informada).
- `aws_s3_bucket_lifecycle_configuration`: regras de ciclo de vida opcionais.
- `aws_s3_bucket_policy` + `aws_iam_policy_document`: nega explicitamente requisicoes que nao usem TLS (`aws:SecureTransport = false`).

## Uso

```
module "bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"

  tags = {
    Environment = "producao"
  }
}
```

## Variaveis principais

| Nome | Descricao | Padrao |
|---|---|---|
| `bucket_name` | Nome globalmente unico do bucket | obrigatorio |
| `force_destroy` | Permite exclusao do bucket com objetos | `false` |
| `enable_versioning` | Habilita versionamento | `true` |
| `kms_key_arn` | ARN de chave KMS para criptografia | `null` (usa AES256) |
| `tags` | Tags adicionais | `{}` |
| `lifecycle_rules` | Regras de ciclo de vida | `[]` |

## Outputs

- `bucket_id`
- `bucket_arn`
- `bucket_domain_name`
- `bucket_regional_domain_name`
- `bucket_versioning_status`

## Seguranca

- Acesso publico bloqueado por padrao em todas as camadas (ACL e politica de bucket).
- ACLs desabilitadas via `BucketOwnerEnforced`.
- Criptografia server-side obrigatoria (AES256 ou SSE-KMS).
- Politica de bucket nega trafego sem TLS.
- Nenhuma credencial ou valor sensivel fixo no codigo; regiao e provider configurados sem dependencia de segredos.

## Validacao

```
terraform init -backend=false
terraform validate
```
