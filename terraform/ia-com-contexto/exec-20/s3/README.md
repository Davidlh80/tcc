# S3 Bucket - dev-tcc-s3-\<finalidade\>

## Visao geral

Este modulo provisiona um bucket Amazon S3 seguindo os padroes internos da organizacao para nomenclatura, tags e seguranca. O bucket e criado com:

- Nomenclatura padronizada `<ambiente>-<sistema>-s3-<finalidade>`;
- Bloqueio total de acesso publico (as quatro flags do Public Access Block);
- Criptografia server-side habilitada por padrao com AES256 (SSE-S3), com suporte opcional a `aws:kms`;
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- Versionamento configuravel por variavel, com padrao `Enabled`;
- Tags obrigatorias da organizacao aplicadas automaticamente.

## Variaveis

| Nome                | Tipo          | Obrigatoria | Descricao                                                                                   |
|---------------------|---------------|:-----------:|-----------------------------------------------------------------------------------------------|
| `environment`       | `string`      | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`            | `string`      | Sim         | Nome curto do sistema dono do recurso, usado na nomenclatura padronizada.                     |
| `region`            | `string`      | Nao         | Regiao AWS onde o bucket sera criado. Padrao: `us-east-1`.                                    |
| `additional_tags`   | `map(string)` | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.               |
| `purpose`           | `string`      | Sim         | Finalidade do bucket, usada na nomenclatura padronizada (ex.: `logs`, `artifacts`).            |
| `enable_versioning` | `bool`        | Nao         | Habilita o versionamento do bucket. Padrao: `true` (status `Enabled`).                         |
| `sse_algorithm`     | `string`      | Nao         | Algoritmo de criptografia server-side (`AES256` ou `aws:kms`). Padrao: `AES256`.               |
| `kms_master_key_id` | `string`      | Nao         | ID/ARN da chave KMS, usado apenas quando `sse_algorithm = "aws:kms"`. Padrao: `null`.           |

## Outputs

| Nome          | Descricao                          |
|---------------|-------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.           |
| `bucket_arn`  | ARN do bucket S3 criado.            |
| `bucket_id`   | ID do bucket S3 criado.             |

## Exemplo de uso

```hcl
module "s3_logs" {
  source = "./s3"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "logs"

  enable_versioning = true
  sse_algorithm     = "AES256"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
