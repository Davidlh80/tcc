# Blueprint Terraform — Bucket Amazon S3

Blueprint autonomo para provisionamento de um bucket S3 na AWS, com configuracoes seguras por padrao: acesso publico bloqueado, criptografia server-side obrigatoria, versionamento habilitado e propriedade de objetos enforced pelo dono do bucket.

## Recursos criados

- `aws_s3_bucket` — bucket S3.
- `aws_s3_bucket_ownership_controls` — forca `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block` — bloqueia qualquer forma de acesso publico.
- `aws_s3_bucket_versioning` — controla o versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia SSE-S3 (AES256) por padrao, ou SSE-KMS se uma chave for informada.
- `aws_s3_bucket_lifecycle_configuration` — regras de ciclo de vida opcionais (expiracao de objetos atuais e versoes antigas).

## Requisitos

- Terraform >= 1.5.0
- Provider AWS (`hashicorp/aws`) ~> 5.0
- Credenciais AWS configuradas no ambiente de execucao (nao incluidas neste blueprint)

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"

  tags = {
    Environment = "dev"
    Owner       = "time-plataforma"
  }
}
```

## Variaveis principais

| Nome | Descricao | Tipo | Padrao |
|---|---|---|---|
| `aws_region` | Regiao AWS de criacao dos recursos | `string` | `us-east-1` |
| `bucket_name` | Nome globalmente unico do bucket | `string` | — (obrigatorio) |
| `force_destroy` | Permite exclusao do bucket com objetos | `bool` | `false` |
| `versioning_enabled` | Habilita versionamento | `bool` | `true` |
| `kms_key_arn` | ARN de chave KMS para SSE-KMS | `string` | `null` |
| `tags` | Tags aplicadas ao bucket | `map(string)` | `{}` |
| `lifecycle_rules` | Regras de ciclo de vida | `list(object)` | `[]` |

## Outputs

| Nome | Descricao |
|---|---|
| `bucket_id` | Nome do bucket |
| `bucket_arn` | ARN do bucket |
| `bucket_domain_name` | Nome de dominio do bucket |
| `bucket_regional_domain_name` | Nome de dominio regional do bucket |
| `versioning_status` | Status do versionamento |
| `encryption_algorithm` | Algoritmo de criptografia aplicado |

## Seguranca

- Acesso publico bloqueado por padrao (`aws_s3_bucket_public_access_block` com todas as flags em `true`).
- ACLs desabilitadas via `BucketOwnerEnforced`.
- Criptografia server-side obrigatoria em todos os objetos.
- Nenhuma credencial ou valor sensivel fixo esta presente neste codigo.

## Validacao

```
terraform init -backend=false
terraform validate
```
