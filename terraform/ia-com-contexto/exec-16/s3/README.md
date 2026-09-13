# S3 Bucket

## Visao geral

Este template provisiona um bucket Amazon S3 seguindo os padroes organizacionais de nomenclatura, tags e seguranca. O bucket e criado com:

- bloqueio total de acesso publico (quatro flags do Public Access Block ativadas);
- criptografia server-side por padrao com o algoritmo AES256 (SSE-S3);
- bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- versionamento configuravel por variavel, com padrao `Enabled`;
- nome composto no padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `dev-tcc-s3-logs`);
- tags obrigatorias aplicadas automaticamente e combinadas com tags adicionais informadas pelo consumidor.

## Variaveis

| Nome                | Tipo          | Obrigatoria | Descricao                                                                 |
|---------------------|---------------|-------------|----------------------------------------------------------------------------|
| `environment`        | `string`      | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                           |
| `system`              | `string`      | Sim         | Identificador do sistema/produto ao qual o recurso pertence.               |
| `region`              | `string`      | Sim         | Regiao AWS onde o recurso sera provisionado.                                |
| `purpose`             | `string`      | Sim         | Finalidade do bucket, usada na composicao do nome (ex.: `logs`).           |
| `versioning_status`   | `string`      | Nao         | Estado do versionamento (`Enabled` ou `Suspended`). Padrao: `Enabled`.     |
| `additional_tags`     | `map(string)` | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.          |

## Outputs

| Nome          | Descricao                          |
|---------------|-------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.           |
| `bucket_arn`  | ARN do bucket S3 criado.            |
| `bucket_id`   | ID do bucket S3 criado.             |

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
