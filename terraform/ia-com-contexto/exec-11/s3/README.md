# S3 Bucket

## Visao geral

Este modulo provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O bucket e criado com:

- nome padronizado no formato `<ambiente>-<sistema>-s3-<finalidade>`;
- bloqueio das quatro flags do Public Access Block (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`);
- criptografia server-side padrao AES256 (SSE-S3);
- bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- versionamento configuravel por variavel, com padrao `Enabled`;
- tags obrigatorias da organizacao aplicadas automaticamente.

## Variaveis

| Nome                | Tipo          | Obrigatoria | Descricao                                                                 |
|---------------------|---------------|-------------|----------------------------------------------------------------------------|
| `environment`        | `string`      | Sim         | Ambiente de implantacao (`dev`, `hml`, `prd`).                             |
| `system`             | `string`      | Sim         | Identificador do sistema/aplicacao proprietaria do recurso.                |
| `region`             | `string`      | Sim         | Regiao AWS onde o bucket sera provisionado.                                |
| `purpose`            | `string`      | Sim         | Finalidade do bucket, usada na composicao do nome (ex.: `logs`).           |
| `versioning_status`  | `string`      | Nao         | Status do versionamento do bucket (`Enabled` ou `Suspended`). Padrao: `Enabled`. |
| `additional_tags`    | `map(string)` | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao.         |

## Outputs

| Nome          | Descricao                              |
|---------------|-----------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.                |
| `bucket_arn`  | ARN do bucket S3 criado.                 |
| `bucket_id`   | Identificador (ID) do bucket S3 criado.  |

## Exemplo de uso

```hcl
module "s3_logs" {
  source = "./caminho/para/este/modulo"

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
