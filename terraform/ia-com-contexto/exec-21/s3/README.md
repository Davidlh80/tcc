# S3 - dev-tcc-s3-\<finalidade\>

## 1. Visao geral

Este template provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O recurso e criado com:

- nome padronizado no formato `<ambiente>-<sistema>-s3-<finalidade>`;
- bloqueio das quatro flags do Public Access Block (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`);
- criptografia server-side habilitada, com algoritmo `AES256` por padrao (configuravel para `aws:kms`);
- bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- versionamento configuravel por variavel, com padrao `Enabled`;
- tags obrigatorias da organizacao aplicadas automaticamente.

## 2. Variaveis

| Nome                | Tipo          | Obrigatoria | Descricao                                                                 |
|---------------------|---------------|:-----------:|----------------------------------------------------------------------------|
| `environment`        | `string`      | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                          |
| `system`             | `string`      | Nao         | Nome do sistema/produto. Padrao: `tcc`.                                   |
| `region`             | `string`      | Nao         | Regiao AWS de provisionamento. Padrao: `us-east-1`.                       |
| `purpose`            | `string`      | Sim         | Finalidade do bucket, usada na composicao do nome (ex.: `logs`).          |
| `additional_tags`    | `map(string)` | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.         |
| `versioning_status`  | `string`      | Nao         | Status do versionamento (`Enabled` ou `Suspended`). Padrao: `Enabled`.    |
| `sse_algorithm`      | `string`      | Nao         | Algoritmo de criptografia server-side (`AES256` ou `aws:kms`). Padrao: `AES256`. |
| `kms_key_id`         | `string`      | Nao         | ID/ARN da chave KMS, usado somente quando `sse_algorithm = "aws:kms"`.    |

## 3. Outputs

| Nome          | Descricao                              |
|----------------|------------------------------------------|
| `bucket_name`  | Nome (identificador) do bucket S3 criado. |
| `bucket_arn`   | ARN do bucket S3 criado.                  |
| `bucket_id`    | ID do bucket S3 criado.                   |

## 4. Exemplo de uso

```hcl
module "s3_logs" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "logs"

  versioning_status = "Enabled"
  sse_algorithm     = "AES256"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
