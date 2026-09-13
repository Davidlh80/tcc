# S3 Bucket - dev-tcc-s3-logs (exemplo)

## Visao geral

Este template Terraform provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O bucket e criado com as seguintes protecoes por padrao:

- Bloqueio das quatro flags do Public Access Block (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`);
- Criptografia server-side com algoritmo AES256 (SSE-S3);
- Bucket policy que nega explicitamente qualquer requisicao que nao utilize `aws:SecureTransport`;
- Versionamento configuravel por variavel, com padrao `Enabled`;
- Nomenclatura padronizada no formato `<ambiente>-<sistema>-s3-<finalidade>`;
- Tags obrigatorias da organizacao aplicadas automaticamente.

## Variaveis

| Nome                | Tipo          | Obrigatoria | Descricao                                                                                      |
|---------------------|---------------|-------------|--------------------------------------------------------------------------------------------------|
| `environment`        | `string`      | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                 |
| `system`             | `string`      | Sim         | Identificador do sistema ou aplicacao dono do bucket.                                            |
| `region`             | `string`      | Sim         | Regiao AWS onde o bucket sera criado.                                                            |
| `purpose`            | `string`      | Sim         | Finalidade do bucket, usada na composicao do nome (ex.: `logs`, `backups`, `artifacts`).          |
| `versioning_status`  | `string`      | Nao         | Estado do versionamento do bucket (`Enabled` ou `Suspended`). Padrao: `Enabled`.                  |
| `additional_tags`    | `map(string)` | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                  |

## Outputs

| Nome          | Descricao                              |
|---------------|-----------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.                |
| `bucket_arn`  | ARN do bucket S3 criado.                 |
| `bucket_id`   | Identificador (ID) do bucket S3 criado.  |

## Exemplo de uso

```hcl
module "s3_logs" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "logs"

  versioning_status = "Enabled"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
