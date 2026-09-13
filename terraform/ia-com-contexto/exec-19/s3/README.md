# S3 Bucket — Blueprint Terraform

## 1. Visão geral do recurso

Este blueprint provisiona um bucket Amazon S3 seguindo os padrões internos de Infraestrutura como Código da organização. O recurso é criado com:

- Nomenclatura padronizada no formato `<ambiente>-<sistema>-s3-<finalidade>`;
- Bloqueio total de acesso público, com as quatro flags do Public Access Block habilitadas;
- Criptografia server-side habilitada por padrão com o algoritmo AES256 (SSE-S3);
- Bucket policy que nega explicitamente qualquer requisição realizada sem `aws:SecureTransport`;
- Versionamento configurável por variável, com padrão `Enabled`;
- Tags obrigatórias aplicadas automaticamente, com suporte a tags adicionais via variável.

## 2. Tabela de variáveis

| Nome                | Tipo          | Obrigatória | Descrição                                                                                   |
|----------------------|---------------|:-----------:|-----------------------------------------------------------------------------------------------|
| `environment`        | `string`      | Sim         | Ambiente de implantação do recurso. Valores permitidos: `dev`, `hml`, `prd`.                 |
| `system`              | `string`      | Sim         | Nome curto do sistema ou aplicação dona do recurso, usado na nomenclatura padronizada.        |
| `region`              | `string`      | Sim         | Região AWS onde o bucket S3 será criado.                                                     |
| `purpose`             | `string`      | Sim         | Finalidade do bucket, usada na nomenclatura padronizada (ex.: `logs`, `artifacts`).           |
| `versioning_status`   | `string`      | Não         | Status do versionamento do bucket. Valores permitidos: `Enabled`, `Suspended`. Padrão: `Enabled`. |
| `additional_tags`     | `map(string)` | Não         | Tags adicionais mescladas com as tags obrigatórias da organização. Padrão: `{}`.              |

## 3. Tabela de outputs

| Nome          | Descrição                          |
|----------------|--------------------------------------|
| `bucket_name`  | Nome do bucket S3 criado.            |
| `bucket_arn`   | ARN do bucket S3 criado.             |
| `bucket_id`    | ID do bucket S3 criado.              |

## 4. Exemplo de uso

```hcl
module "s3_logs" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "logs"

  versioning_status = "Enabled"

  additional_tags = {
    Team = "platform"
  }
}
```
