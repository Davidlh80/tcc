# S3 Bucket - dev-tcc-s3-logs (exemplo)

## 1. Visao geral

Este template provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O nome do bucket e composto automaticamente no formato `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `dev-tcc-s3-logs`).

O bucket e criado com as seguintes protecoes por padrao:

- Bloqueio das quatro flags do Public Access Block (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`).
- Criptografia server-side habilitada (SSE-S3/AES256 por padrao, com suporte opcional a `aws:kms`).
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`.
- Versionamento configuravel por variavel, com padrao `Enabled`.
- Tags obrigatorias da organizacao aplicadas automaticamente.

## 2. Variaveis

| Nome                | Tipo          | Obrigatoria | Descricao                                                                                   |
|---------------------|---------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`       | `string`      | Sim         | Ambiente de implantacao do recurso (`dev`, `hml` ou `prd`).                                  |
| `system`            | `string`      | Sim         | Nome do sistema ou aplicacao ao qual o bucket pertence.                                       |
| `region`            | `string`      | Nao         | Regiao AWS onde o bucket sera criado. Padrao: `us-east-1`.                                    |
| `purpose`           | `string`      | Sim         | Finalidade do bucket, utilizada na composicao do nome (ex.: `logs`, `artifacts`).             |
| `versioning_status` | `string`      | Nao         | Status do versionamento (`Enabled` ou `Suspended`). Padrao: `Enabled`.                        |
| `sse_algorithm`     | `string`      | Nao         | Algoritmo de criptografia server-side (`AES256` ou `aws:kms`). Padrao: `AES256`.               |
| `kms_master_key_id` | `string`      | Nao         | ARN da chave KMS, obrigatorio apenas quando `sse_algorithm` for `aws:kms`. Padrao: `null`.     |
| `force_destroy`     | `bool`        | Nao         | Permite excluir o bucket mesmo com objetos. Padrao: `false`.                                   |
| `additional_tags`   | `map(string)` | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.               |

## 3. Outputs

| Nome          | Descricao                              |
|---------------|------------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.                |
| `bucket_arn`  | ARN do bucket S3 criado.                 |
| `bucket_id`   | Identificador (ID) do bucket S3 criado.  |

## 4. Exemplo de uso

```hcl
module "s3_logs" {
  source = "./s3"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "logs"

  versioning_status = "Enabled"
  sse_algorithm     = "AES256"

  additional_tags = {
    Team = "plataforma"
  }
}
```
