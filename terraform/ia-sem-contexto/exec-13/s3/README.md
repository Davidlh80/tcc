# Modulo Terraform — Bucket S3 seguro

Provisiona um bucket Amazon S3 com configuracoes seguras por padrao: bloqueio
total de acesso publico, criptografia server-side habilitada, controle de
propriedade de objetos (sem ACLs) e versionamento configuravel.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal, com tags padronizadas.
- `aws_s3_bucket_versioning` — versionamento habilitado ou suspenso conforme variavel.
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia SSE-S3 (AES256) por padrao, ou SSE-KMS quando uma chave e informada.
- `aws_s3_bucket_public_access_block` — bloqueia ACLs e politicas publicas em todas as dimensoes.
- `aws_s3_bucket_ownership_controls` — forca `BucketOwnerEnforced`, desabilitando ACLs.

## Requisitos

- Terraform >= 1.5.0
- Provider AWS (`hashicorp/aws`) ~> 5.0
- Credenciais AWS validas apenas para `plan`/`apply` (nao sao necessarias para `init -backend=false` ou `validate`).

## Como usar

```
module "bucket" {
  source = "./"

  bucket_name        = "minha-empresa-dados-123456"
  aws_region         = "us-east-1"
  environment        = "prod"
  versioning_enabled = true

  tags = {
    Projeto = "exemplo"
  }
}
```

Para usar criptografia SSE-KMS, informe o ARN de uma chave existente:

```
kms_key_arn = "arn:aws:kms:us-east-1:111122223333:key/abcd-1234"
```

## Variaveis

| Nome                 | Tipo          | Padrao      | Descricao                                                        |
|----------------------|---------------|-------------|-------------------------------------------------------------------|
| `bucket_name`        | string        | (obrigatorio)| Nome globalmente unico do bucket S3.                              |
| `aws_region`         | string        | `us-east-1` | Regiao AWS onde o bucket sera criado.                             |
| `environment`        | string        | `dev`       | Ambiente usado para tagueamento.                                  |
| `versioning_enabled` | bool          | `true`      | Habilita ou suspende o versionamento de objetos.                  |
| `kms_key_arn`        | string        | `null`      | ARN de chave KMS para SSE-KMS; se nulo, usa SSE-S3 (AES256).      |
| `tags`               | map(string)   | `{}`        | Tags adicionais mescladas com as tags padrao do bucket.           |

## Outputs

| Nome                          | Descricao                                                  |
|--------------------------------|-------------------------------------------------------------|
| `bucket_id`                    | Nome (ID) do bucket S3 criado.                               |
| `bucket_arn`                   | ARN do bucket S3 criado.                                     |
| `bucket_domain_name`           | Nome de dominio do bucket.                                   |
| `bucket_regional_domain_name`  | Nome de dominio regional do bucket.                          |
| `versioning_status`            | Status configurado para o versionamento (Enabled/Suspended). |
| `encryption_algorithm`         | Algoritmo de criptografia server-side aplicado (AES256/aws:kms). |

## Consideracoes de seguranca

- Acesso publico e bloqueado em todas as camadas (ACLs e politicas de bucket).
- ACLs sao desabilitadas via `BucketOwnerEnforced`, forcando controle de acesso exclusivamente por politicas IAM/bucket policy.
- Criptografia server-side e sempre habilitada, com opcao de usar chave KMS gerenciada pelo cliente.
- Nenhum valor sensivel ou credencial e fixado no codigo; todos os parametros configuraveis sao expostos via variaveis.
