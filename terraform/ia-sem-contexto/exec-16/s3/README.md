# Modulo Terraform: Bucket S3 Seguro

## Descricao

Esta blueprint provisiona um bucket Amazon S3 com configuracoes de seguranca aplicadas por padrao:

- Bloqueio total de acesso publico (`aws_s3_bucket_public_access_block`).
- Criptografia do lado do servidor habilitada (SSE-S3 por padrao, ou SSE-KMS se uma chave for informada).
- Versionamento configuravel por variavel (habilitado por padrao).
- `Bucket Owner Enforced` para desabilitar ACLs e simplificar o controle de acesso via IAM/policies.
- Tags configuraveis aplicadas ao recurso.

## Uso

```hcl
module "bucket" {
  source = "./"

  bucket_name        = "minha-empresa-dados-123456"
  versioning_enabled = true

  tags = {
    Ambiente = "producao"
    Time     = "plataforma"
  }
}
```

## Requisitos

| Nome      | Versao    |
|-----------|-----------|
| terraform | >= 1.5.0  |
| aws       | >= 5.0.0  |

## Variaveis

| Nome                 | Descricao                                                         | Tipo          | Padrao | Obrigatorio |
|----------------------|--------------------------------------------------------------------|---------------|--------|-------------|
| `bucket_name`        | Nome globalmente unico do bucket S3.                               | `string`      | -      | sim         |
| `versioning_enabled` | Habilita o versionamento de objetos no bucket.                     | `bool`        | `true` | nao         |
| `kms_key_arn`        | ARN de chave KMS para criptografia SSE-KMS. Nulo usa SSE-S3.       | `string`      | `null` | nao         |
| `tags`               | Mapa de tags adicionais aplicadas ao bucket.                       | `map(string)` | `{}`   | nao         |

## Outputs

| Nome                           | Descricao                                                  |
|--------------------------------|--------------------------------------------------------------|
| `bucket_id`                    | Identificador (nome) do bucket S3 criado.                   |
| `bucket_arn`                   | ARN do bucket S3 criado.                                     |
| `bucket_regional_domain_name`  | Nome de dominio regional do bucket.                          |
| `versioning_status`            | Status atual do versionamento do bucket.                     |

## Seguranca

- Acesso publico e bloqueado em todas as camadas (ACLs e policies).
- Criptografia do lado do servidor e obrigatoria para todos os objetos.
- ACLs sao desabilitadas via `Bucket Owner Enforced`, reduzindo a superficie de erro de configuracao.
- Nenhuma credencial ou valor sensivel esta fixado no codigo; todos os parametros sao expostos via variaveis.
