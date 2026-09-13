# S3 Bucket

## Visao geral

Este modulo provisiona um bucket Amazon S3 seguindo os padroes organizacionais de nomenclatura, tags e seguranca. O bucket e criado com:

- Bloqueio total de acesso publico (as quatro flags do Public Access Block habilitadas);
- Criptografia server-side habilitada por padrao (AES256, configuravel para aws:kms);
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- Versionamento configuravel por variavel, com padrao `Enabled`;
- Nomenclatura no padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`;
- Tags obrigatorias da organizacao aplicadas automaticamente.

## Variaveis

| Nome                | Tipo          | Obrigatoria | Descricao                                                                          |
|---------------------|---------------|-------------|--------------------------------------------------------------------------------------|
| `environment`        | `string`      | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                      |
| `system`             | `string`      | Sim         | Nome do sistema/produto, usado na nomenclatura padrao.                               |
| `region`             | `string`      | Nao         | Regiao AWS onde o recurso sera provisionado. Padrao: `us-east-1`.                     |
| `purpose`            | `string`      | Sim         | Finalidade do bucket, usada na nomenclatura padrao (ex.: `logs`, `artifacts`).        |
| `additional_tags`    | `map(string)` | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.                     |
| `versioning_status`  | `string`      | Nao         | Status do versionamento (`Enabled` ou `Suspended`). Padrao: `Enabled`.                |
| `sse_algorithm`      | `string`      | Nao         | Algoritmo de criptografia server-side (`AES256` ou `aws:kms`). Padrao: `AES256`.      |
| `kms_key_id`         | `string`      | Nao         | ID/ARN da chave KMS, obrigatorio somente quando `sse_algorithm = "aws:kms"`.          |
| `force_destroy`      | `bool`        | Nao         | Permite exclusao do bucket com objetos existentes. Padrao: `false`.                   |

## Outputs

| Nome          | Descricao                          |
|---------------|-------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.            |
| `bucket_arn`  | ARN do bucket S3 criado.             |
| `bucket_id`   | ID do bucket S3 criado.              |

## Exemplo de uso

```hcl
module "s3_logs" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  purpose     = "logs"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
