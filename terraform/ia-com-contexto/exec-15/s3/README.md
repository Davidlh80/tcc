# S3 Bucket - dev-tcc-s3-logs (exemplo)

## Visao geral

Este modulo provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O recurso e criado com:

- Bloqueio total de acesso publico (quatro flags do Public Access Block habilitadas);
- Criptografia server-side habilitada por padrao (AES256, configuravel para aws:kms);
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- Versionamento configuravel por variavel, com padrao `Enabled`;
- Nomenclatura padronizada no formato `<ambiente>-<sistema>-<recurso>-<finalidade>`;
- Tags obrigatorias aplicadas automaticamente, combinaveis com tags adicionais.

## Variaveis

| Nome                | Tipo         | Obrigatoria | Descricao                                                                 |
|---------------------|--------------|-------------|----------------------------------------------------------------------------|
| `environment`        | `string`     | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                          |
| `system`              | `string`     | Sim         | Identificador do sistema, usado no padrao de nomenclatura.                |
| `region`              | `string`     | Nao         | Regiao AWS onde o recurso sera criado. Padrao: `us-east-1`.               |
| `additional_tags`     | `map(string)`| Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.         |
| `purpose`             | `string`     | Sim         | Finalidade do bucket, usada no padrao de nomenclatura.                    |
| `versioning_status`   | `string`     | Nao         | Status do versionamento (`Enabled` ou `Suspended`). Padrao: `Enabled`.    |
| `sse_algorithm`       | `string`     | Nao         | Algoritmo de criptografia server-side (`AES256` ou `aws:kms`). Padrao: `AES256`. |

## Outputs

| Nome           | Descricao                              |
|----------------|------------------------------------------|
| `bucket_name`  | Nome do bucket S3 criado.                |
| `bucket_arn`   | ARN do bucket S3 criado.                 |
| `bucket_id`    | ID do bucket S3 criado.                  |

## Exemplo de uso

```hcl
module "s3_logs" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  purpose     = "logs"
  region      = "us-east-1"

  versioning_status = "Enabled"
  sse_algorithm     = "AES256"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
