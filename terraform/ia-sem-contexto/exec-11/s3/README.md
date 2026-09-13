# Blueprint Terraform — Bucket Amazon S3

Blueprint autônoma para provisionamento de um bucket Amazon S3 seguro por padrão, sem vínculo a padrões organizacionais específicos.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_versioning` — versionamento de objetos (habilitado por padrão).
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side (SSE-S3 por padrão, SSE-KMS opcional via `kms_key_arn`).
- `aws_s3_bucket_public_access_block` — bloqueio total de acesso público.
- `aws_s3_bucket_ownership_controls` — ownership `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_logging` — logging de acesso opcional, habilitado ao informar `logging_target_bucket`.
- `aws_s3_bucket_lifecycle_configuration` — regras de ciclo de vida opcionais via `lifecycle_rules`.

## Postura de segurança padrão

- Acesso público bloqueado em todas as dimensões (ACLs e políticas).
- Criptografia server-side sempre habilitada.
- ACLs desabilitadas em favor de políticas de bucket (ownership enforced).
- Versionamento habilitado por padrão para proteção contra sobrescrita/exclusão acidental.
- `force_destroy` desabilitado por padrão para evitar exclusão acidental de dados.

## Uso

```hcl
module "bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"
  environment = "prod"

  tags = {
    Owner = "time-plataforma"
  }
}
```

## Variáveis principais

| Nome | Descrição | Padrão |
|---|---|---|
| `aws_region` | Região AWS de provisionamento | `us-east-1` |
| `bucket_name` | Nome único do bucket | — (obrigatório) |
| `environment` | Ambiente para fins de tag | `dev` |
| `force_destroy` | Permite destruir bucket não vazio | `false` |
| `enable_versioning` | Habilita versionamento | `true` |
| `kms_key_arn` | ARN de chave KMS para SSE-KMS | `null` |
| `logging_target_bucket` | Bucket de destino de logs de acesso | `null` |
| `logging_target_prefix` | Prefixo dos logs de acesso | `log/` |
| `lifecycle_rules` | Regras de ciclo de vida | `[]` |
| `tags` | Tags adicionais | `{}` |

## Outputs

| Nome | Descrição |
|---|---|
| `bucket_id` | Nome do bucket |
| `bucket_arn` | ARN do bucket |
| `bucket_domain_name` | Domínio virtual-hosted-style |
| `bucket_regional_domain_name` | Domínio regional |
| `bucket_region` | Região do bucket |

## Validação

```bash
terraform init -backend=false
terraform validate
```

Nenhuma credencial real é necessária para validação sintática, pois a região possui valor padrão e nenhuma chamada de API é feita durante `validate`.
