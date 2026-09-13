# Blueprint Terraform — Bucket Amazon S3

Provisiona um bucket Amazon S3 com configuracoes seguras por padrao: bloqueio total de acesso publico, criptografia server-side habilitada, versionamento habilitado e ownership controls forcando `BucketOwnerEnforced` (desabilita ACLs).

## Recursos criados

- `aws_s3_bucket.this`
- `aws_s3_bucket_versioning.this`
- `aws_s3_bucket_server_side_encryption_configuration.this`
- `aws_s3_bucket_public_access_block.this`
- `aws_s3_bucket_ownership_controls.this`

## Uso

```hcl
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-unico"

  tags = {
    ambiente = "producao"
    time     = "plataforma"
  }
}
```

## Requisitos

| Nome | Versao |
|------|--------|
| terraform | >= 1.5.0 |
| aws | ~> 5.0 |

## Variaveis

| Nome | Descricao | Tipo | Default | Obrigatorio |
|------|-----------|------|---------|-------------|
| bucket_name | Nome globalmente unico do bucket S3 | string | n/a | sim |
| force_destroy | Permite destruir o bucket mesmo com objetos | bool | false | nao |
| enable_versioning | Habilita versionamento de objetos | bool | true | nao |
| sse_algorithm | Algoritmo de criptografia (AES256 ou aws:kms) | string | "AES256" | nao |
| kms_key_arn | ARN da chave KMS quando sse_algorithm = aws:kms | string | null | nao |
| block_public_access | Bloqueia acesso publico ao bucket | bool | true | nao |
| tags | Tags adicionais do bucket | map(string) | {} | nao |

## Outputs

| Nome | Descricao |
|------|-----------|
| bucket_id | Nome (ID) do bucket criado |
| bucket_arn | ARN do bucket criado |
| bucket_domain_name | Nome de dominio do bucket |
| bucket_regional_domain_name | Nome de dominio regional do bucket |
| bucket_region | Regiao AWS do bucket |

## Seguranca

- Acesso publico bloqueado por padrao via `aws_s3_bucket_public_access_block`.
- ACLs desabilitadas via `BucketOwnerEnforced`, forcando controle de acesso somente por politicas IAM/bucket policy.
- Criptografia server-side habilitada por padrao (`AES256`), com suporte opcional a `aws:kms`.
- Versionamento habilitado por padrao para protecao contra sobrescrita/exclusao acidental de objetos.

## Validacao

```bash
terraform init -backend=false
terraform validate
```
