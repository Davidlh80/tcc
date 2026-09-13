# dev-tcc-s3-\<finalidade\>

## Visao geral

Este modulo Terraform provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O bucket criado:

- segue o padrao de nomenclatura `<ambiente>-<sistema>-s3-<finalidade>`;
- possui as quatro flags do Public Access Block habilitadas (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`);
- possui criptografia server-side habilitada, com algoritmo padrao `AES256` (SSE-S3), configuravel via variavel;
- possui uma bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- possui versionamento configuravel por variavel, com padrao `Enabled`;
- aplica as tags obrigatorias da organizacao, mescladas com tags adicionais informadas pelo consumidor do modulo.

## Variaveis

| Nome               | Tipo          | Obrigatoria | Descricao                                                                          |
|--------------------|---------------|-------------|-------------------------------------------------------------------------------------|
| `environment`      | `string`      | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                    |
| `system`           | `string`      | Sim         | Nome do sistema, utilizado no padrao de nomenclatura.                              |
| `region`           | `string`      | Sim         | Regiao AWS onde o bucket sera provisionado.                                        |
| `purpose`          | `string`      | Sim         | Finalidade do bucket, utilizada no padrao de nomenclatura (ex.: `logs`).           |
| `additional_tags`  | `map(string)` | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.   |
| `sse_algorithm`    | `string`      | Nao         | Algoritmo de criptografia server-side (`AES256` ou `aws:kms`). Padrao: `AES256`.   |
| `versioning_status`| `string`      | Nao         | Status do versionamento (`Enabled`, `Suspended` ou `Disabled`). Padrao: `Enabled`. |

## Outputs

| Nome          | Descricao                              |
|---------------|-----------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.               |
| `bucket_arn`  | ARN do bucket S3 criado.                |
| `bucket_id`   | Identificador (ID) do bucket S3 criado. |

## Exemplo de uso

```hcl
module "s3_logs" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "logs"

  additional_tags = {
    Team = "plataforma"
  }
}
```
