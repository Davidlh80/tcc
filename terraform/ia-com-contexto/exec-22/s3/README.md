# S3 Bucket - dev-tcc-s3-\<finalidade\>

## Visao geral

Este template provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O bucket e criado com:

- Nome padronizado no formato `<ambiente>-<sistema>-s3-<finalidade>`;
- Bloqueio total de acesso publico (quatro flags do Public Access Block habilitadas);
- Criptografia server-side com o algoritmo AES256 (SSE-S3);
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- Versionamento configuravel via variavel, com padrao `Enabled`;
- Tags obrigatorias da organizacao aplicadas automaticamente.

## Variaveis

| Nome                | Tipo          | Obrigatoria | Descricao                                                                 |
|---------------------|---------------|-------------|----------------------------------------------------------------------------|
| `environment`        | `string`      | Sim         | Ambiente de implantacao (`dev`, `hml`, `prd`).                             |
| `system`             | `string`      | Sim         | Identificador do sistema ou produto.                                       |
| `region`             | `string`      | Sim         | Regiao AWS onde os recursos serao provisionados.                           |
| `additional_tags`    | `map(string)` | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.          |
| `purpose`            | `string`      | Sim         | Finalidade do bucket, usada na composicao do nome (ex.: `logs`).           |
| `versioning_status`  | `string`      | Nao         | Status do versionamento (`Enabled` ou `Suspended`). Padrao: `Enabled`.     |

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

  versioning_status = "Enabled"
}
```
