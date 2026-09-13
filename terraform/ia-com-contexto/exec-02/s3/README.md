# S3 Bucket - Blueprint Terraform

## 1. Visao geral do recurso

Este blueprint provisiona um bucket Amazon S3 aderente aos padroes organizacionais de nomenclatura, tags, seguranca e governanca. O bucket e criado com:

- nome padronizado no formato `<ambiente>-<sistema>-s3-<finalidade>`;
- bloqueio total de acesso publico (quatro flags do Public Access Block habilitadas);
- criptografia server-side por padrao com algoritmo AES256 (SSE-S3);
- bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- versionamento configuravel por variavel, com padrao `Enabled`;
- tags obrigatorias da organizacao aplicadas automaticamente.

## 2. Variaveis

| Nome                | Tipo         | Obrigatoria | Descricao                                                                          |
|---------------------|--------------|-------------|-------------------------------------------------------------------------------------|
| `environment`       | string       | Sim         | Ambiente de implantacao do recurso. Valores permitidos: `dev`, `hml`, `prd`.        |
| `system`            | string       | Sim         | Nome do sistema ou aplicacao proprietaria do recurso.                              |
| `region`            | string       | Nao         | Regiao AWS onde o bucket sera provisionado. Padrao: `us-east-1`.                   |
| `purpose`           | string       | Sim         | Finalidade do bucket, usada na nomenclatura padronizada (ex.: `logs`).             |
| `versioning_status` | string       | Nao         | Status do versionamento do bucket (`Enabled` ou `Suspended`). Padrao: `Enabled`.   |
| `additional_tags`   | map(string)  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.   |

## 3. Outputs

| Nome          | Descricao                                |
|---------------|--------------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.                  |
| `bucket_arn`  | ARN do bucket S3 criado.                   |
| `bucket_id`   | Identificador (ID) do bucket S3 criado.    |

## 4. Exemplo de uso

```hcl
module "s3_logs" {
  source = "./modulos/s3"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "logs"

  versioning_status = "Enabled"

  additional_tags = {
    Squad = "plataforma"
  }
}

output "bucket_arn" {
  value = module.s3_logs.bucket_arn
}
```
