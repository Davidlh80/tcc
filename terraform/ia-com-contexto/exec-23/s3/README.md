# S3 Bucket - dev-tcc-s3-<finalidade>

## 1. Visão geral

Este módulo provisiona um bucket Amazon S3 seguindo os padrões internos de nomenclatura, tags e segurança da organização.

O bucket criado possui:

- Nome padronizado no formato `<ambiente>-<sistema>-s3-<finalidade>`;
- Bloqueio total de acesso público, com as quatro flags do Public Access Block ativas;
- Criptografia server-side habilitada por padrão com o algoritmo AES256 (SSE-S3);
- Bucket policy que nega explicitamente qualquer requisição realizada sem `aws:SecureTransport`;
- Versionamento configurável por variável, com padrão `Enabled`;
- Tags obrigatórias aplicadas automaticamente, combinadas com tags adicionais informadas pelo consumidor do módulo.

## 2. Variáveis

| Nome                | Tipo         | Obrigatória | Descrição                                                                                   |
|---------------------|--------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`        | string       | Sim         | Ambiente de implantação do recurso. Valores permitidos: `dev`, `hml`, `prd`.                  |
| `system`              | string       | Sim         | Nome do sistema ou aplicação proprietária do recurso.                                         |
| `region`              | string       | Sim         | Região AWS onde o bucket S3 será criado.                                                      |
| `purpose`             | string       | Sim         | Finalidade do bucket, usada na composição do nome padronizado (ex.: `logs`, `artifacts`).     |
| `versioning_status`   | string       | Não         | Status do versionamento do bucket. Valores permitidos: `Enabled`, `Suspended`. Padrão: `Enabled`. |
| `additional_tags`     | map(string)  | Não         | Tags adicionais a serem mescladas com as tags obrigatórias da organização. Padrão: `{}`.      |

## 3. Outputs

| Nome          | Descrição                          |
|---------------|-------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.           |
| `bucket_arn`  | ARN do bucket S3 criado.            |
| `bucket_id`   | ID do bucket S3 criado.             |

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
    Squad = "plataforma"
  }
}
```
