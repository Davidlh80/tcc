# S3 Bucket - dev-tcc-s3-\<purpose\>

## Visao geral

Este template provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O nome do bucket e composto no formato `<ambiente>-<sistema>-s3-<finalidade>` (ex.: `dev-tcc-s3-logs`).

Controles de seguranca aplicados por padrao:

- Bloqueio das quatro flags do S3 Public Access Block (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`);
- Criptografia server-side com o algoritmo `AES256` (SSE-S3);
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- Versionamento configuravel via variavel, com padrao `Enabled`.

## Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|---|---|---|---|
| `environment` | `string` | Sim | Ambiente de implantacao (`dev`, `hml` ou `prd`). |
| `system` | `string` | Sim | Nome do sistema ou aplicacao dono do recurso. |
| `region` | `string` | Nao (default `us-east-1`) | Regiao AWS onde os recursos serao provisionados. |
| `purpose` | `string` | Sim | Finalidade do bucket, utilizada na composicao do nome (ex.: `logs`). |
| `versioning_status` | `string` | Nao (default `Enabled`) | Status do versionamento do bucket (`Enabled` ou `Suspended`). |
| `force_destroy` | `bool` | Nao (default `false`) | Permite a exclusao do bucket mesmo que ele contenha objetos. |
| `additional_tags` | `map(string)` | Nao (default `{}`) | Tags adicionais mescladas com as tags obrigatorias da organizacao. |

## Outputs

| Nome | Descricao |
|---|---|
| `bucket_name` | Nome do bucket S3 criado. |
| `bucket_arn` | ARN do bucket S3 criado. |
| `bucket_id` | ID (identificador) do bucket S3 criado. |

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
