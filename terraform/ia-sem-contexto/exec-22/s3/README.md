# Modulo Terraform - Bucket S3

Blueprint Terraform para provisionar um bucket Amazon S3 com configuracoes seguras por padrao: bloqueio total de acesso publico, criptografia server-side habilitada, versionamento configuravel e aplicacao de tags.

## Recursos criados

- `aws_s3_bucket.this` — bucket S3 principal.
- `aws_s3_bucket_public_access_block.this` — bloqueia qualquer forma de acesso publico (ACLs e politicas publicas).
- `aws_s3_bucket_versioning.this` — habilita ou suspende o versionamento de objetos conforme variavel.
- `aws_s3_bucket_server_side_encryption_configuration.this` — aplica criptografia server-side por padrao (AES256 ou aws:kms).
- `aws_s3_bucket_ownership_controls.this` — forca a propriedade dos objetos pelo bucket (`BucketOwnerEnforced`), desabilitando ACLs.

## Requisitos

- Terraform >= 1.5.0
- Provider AWS (`hashicorp/aws`) ~> 5.0
- Credenciais AWS configuradas no ambiente de execucao (nao incluidas neste modulo)

## Variaveis

| Nome | Tipo | Padrao | Descricao |
|---|---|---|---|
| `bucket_name` | string | — | Nome globalmente unico do bucket (obrigatorio). |
| `force_destroy` | bool | `false` | Permite destruir o bucket mesmo com objetos armazenados. |
| `versioning_enabled` | bool | `true` | Habilita o versionamento de objetos. |
| `sse_algorithm` | string | `"AES256"` | Algoritmo de criptografia padrao (`AES256` ou `aws:kms`). |
| `kms_key_arn` | string | `null` | ARN da chave KMS, usado somente quando `sse_algorithm = "aws:kms"`. |
| `tags` | map(string) | `{}` | Tags adicionais aplicadas ao bucket. |

## Outputs

| Nome | Descricao |
|---|---|
| `bucket_id` | Nome do bucket criado. |
| `bucket_arn` | ARN do bucket criado. |
| `bucket_regional_domain_name` | Dominio regional do bucket. |
| `versioning_status` | Status efetivo do versionamento (`Enabled`/`Suspended`). |
| `sse_algorithm` | Algoritmo de criptografia configurado. |

## Exemplo de uso

```hcl
module "bucket" {
  source = "./"

  bucket_name        = "meu-bucket-exemplo-123"
  versioning_enabled = true
  sse_algorithm      = "AES256"

  tags = {
    ambiente = "dev"
    projeto  = "exemplo"
  }
}
```

## Validacao

Este modulo pode ser validado sem credenciais reais e sem backend remoto:

```bash
terraform init -backend=false
terraform validate
```

## Observacoes de seguranca

- O acesso publico e bloqueado em todas as suas formas por padrao (`aws_s3_bucket_public_access_block`).
- As ACLs de objeto sao desabilitadas (`BucketOwnerEnforced`), reduzindo risco de exposicao acidental.
- A criptografia server-side e obrigatoria para todos os objetos gravados no bucket.
- Para uso com `aws:kms`, recomenda-se fornecer uma chave KMS gerenciada pelo cliente (CMK) via `kms_key_arn`, em vez da chave gerenciada pela AWS.
