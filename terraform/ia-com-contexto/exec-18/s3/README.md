# S3 Bucket

## Visão geral

Este módulo provisiona um bucket Amazon S3 seguindo os padrões internos de nomenclatura, tags e segurança da organização. O bucket é criado com bloqueio total de acesso público (quatro flags do Public Access Block habilitadas), criptografia server-side padrão (AES256, configurável para aws:kms), negação explícita de requisições sem TLS (`aws:SecureTransport`) via bucket policy, e versionamento controlável por variável (padrão `Enabled`).

O nome do bucket segue o padrão `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo: `dev-tcc-s3-logs`.

## Variáveis

| Nome                | Tipo         | Obrigatória | Descrição                                                                 |
|---------------------|--------------|-------------|----------------------------------------------------------------------------|
| `environment`        | `string`     | Sim         | Ambiente de implantação (`dev`, `hml`, `prd`).                              |
| `system`              | `string`     | Sim         | Nome do sistema ou aplicação proprietária do recurso.                      |
| `region`              | `string`     | Não         | Região AWS onde o bucket será criado. Padrão: `us-east-1`.                 |
| `purpose`             | `string`     | Sim         | Finalidade do bucket, usada na composição do nome (ex.: `logs`, `backups`).|
| `additional_tags`     | `map(string)`| Não         | Tags adicionais mescladas com as tags obrigatórias. Padrão: `{}`.          |
| `versioning_status`   | `string`     | Não         | Status do versionamento (`Enabled` ou `Suspended`). Padrão: `Enabled`.     |
| `sse_algorithm`       | `string`     | Não         | Algoritmo de criptografia server-side (`AES256` ou `aws:kms`). Padrão: `AES256`. |
| `kms_key_id`          | `string`     | Não         | ARN da chave KMS, usado apenas quando `sse_algorithm` for `aws:kms`.       |

## Outputs

| Nome           | Descrição                          |
|-----------------|--------------------------------------|
| `bucket_name`   | Nome do bucket S3 criado.           |
| `bucket_arn`    | ARN do bucket S3 criado.            |
| `bucket_id`     | ID do bucket S3 criado.             |

## Exemplo de uso

```hcl
module "s3_logs" {
  source = "./modules/s3"

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
