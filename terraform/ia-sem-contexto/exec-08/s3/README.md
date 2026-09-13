# Blueprint Terraform — Bucket S3

Blueprint autonoma para provisionamento de um bucket Amazon S3 seguro por padrao, sem vinculo com padroes organizacionais especificos.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_versioning` — controle de versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side (SSE-S3 por padrao ou SSE-KMS se uma chave for informada).
- `aws_s3_bucket_public_access_block` — bloqueio total de acesso publico.
- `aws_s3_bucket_ownership_controls` — forca `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_lifecycle_configuration` — expiracao de versoes nao atuais (opcional).
- `aws_s3_bucket_policy` — nega explicitamente requisicoes sem TLS (opcional, habilitado por padrao).

## Decisoes de seguranca padrao

- Acesso publico bloqueado em todas as dimensoes (ACLs e policies).
- Object Ownership definido como `BucketOwnerEnforced`, eliminando o uso de ACLs.
- Criptografia server-side obrigatoria em todos os objetos.
- Versionamento habilitado por padrao para protecao contra exclusao/sobrescrita acidental.
- Politica de negacao de trafego nao criptografado (TLS obrigatorio).
- `force_destroy` desabilitado por padrao, evitando exclusao acidental de dados.

## Uso

```hcl
module "bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-unico"
  aws_region  = "us-east-1"

  tags = {
    Ambiente = "producao"
  }
}
```

## Variaveis principais

| Nome                        | Descricao                                              | Padrao |
|-----------------------------|---------------------------------------------------------|--------|
| `bucket_name`               | Nome globalmente unico do bucket                        | —      |
| `aws_region`                 | Regiao AWS onde o provider ira operar                  | —      |
| `force_destroy`              | Permite exclusao do bucket com objetos                 | `false`|
| `versioning_enabled`         | Habilita versionamento                                  | `true` |
| `kms_key_arn`                | ARN de chave KMS para SSE-KMS                           | `""`   |
| `lifecycle_expiration_days`  | Dias para expirar versoes antigas (0 = desabilitado)    | `90`   |
| `enforce_tls`                | Nega requisicoes sem TLS                                | `true` |
| `tags`                       | Tags adicionais para o bucket                           | `{}`   |

## Outputs

- `bucket_id`
- `bucket_arn`
- `bucket_regional_domain_name`
- `versioning_status`

## Validacao

```bash
terraform init -backend=false
terraform validate
terraform fmt -check
```

Nao ha dependencia de credenciais reais para os comandos acima; apenas `terraform apply` exige credenciais AWS validas.
