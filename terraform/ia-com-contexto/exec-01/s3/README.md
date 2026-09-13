# S3 Bucket

## Visão geral

Este template provisiona um bucket Amazon S3 seguindo os padrões internos da organização, incluindo:

- Nomenclatura padronizada `<ambiente>-<sistema>-s3-<finalidade>`;
- Bloqueio das quatro flags do Public Access Block;
- Criptografia server-side com AES256 (SSE-S3);
- Bucket policy que nega explicitamente qualquer requisição sem `aws:SecureTransport`;
- Versionamento configurável por variável, com padrão `Enabled`;
- Tags obrigatórias da organização mescladas com tags adicionais.

## Variáveis

| Nome                | Tipo         | Obrigatória | Descrição                                                                 |
|---------------------|--------------|-------------|----------------------------------------------------------------------------|
| `environment`       | string       | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                          |
| `system`            | string       | Sim         | Nome do sistema/aplicação, usado na nomenclatura padronizada.             |
| `region`            | string       | Não         | Região AWS onde o bucket será provisionado. Padrão: `us-east-1`.          |
| `purpose`           | string       | Sim         | Finalidade do bucket, usada na nomenclatura padronizada (ex.: `logs`).    |
| `versioning_status` | string       | Não         | Status do versionamento (`Enabled` ou `Suspended`). Padrão: `Enabled`.    |
| `additional_tags`   | map(string)  | Não         | Tags adicionais mescladas com as tags obrigatórias. Padrão: `{}`.         |

## Outputs

| Nome          | Descrição                              |
|---------------|------------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.                |
| `bucket_arn`  | ARN do bucket S3 criado.                 |
| `bucket_id`   | Identificador (ID) do bucket S3 criado.  |

## Exemplo de uso

```hcl
module "s3_logs" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  purpose     = "logs"
  region      = "us-east-1"

  versioning_status = "Enabled"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
