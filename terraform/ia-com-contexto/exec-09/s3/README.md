# S3 Bucket - dev-tcc-s3-logs (exemplo)

## 1. Visao geral

Este modulo provisiona um bucket Amazon S3 seguindo os padroes internos da organizacao para nomenclatura, tags, seguranca e governanca. O bucket e criado com:

- Bloqueio total de acesso publico (quatro flags do Public Access Block ativas);
- Criptografia server-side com o algoritmo padrao da organizacao (SSE-S3/AES256);
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- Versionamento configuravel por variavel, com padrao `Enabled`;
- Nomenclatura no padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`;
- Tags obrigatorias da organizacao aplicadas automaticamente.

## 2. Variaveis

| Nome                | Tipo         | Obrigatoria | Descricao                                                              |
|---------------------|--------------|-------------|--------------------------------------------------------------------------|
| `environment`       | string       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                        |
| `system`             | string       | Sim         | Nome do sistema ou projeto ao qual o bucket pertence.                   |
| `region`             | string       | Sim         | Regiao AWS onde o bucket sera provisionado.                             |
| `purpose`            | string       | Sim         | Finalidade do bucket, utilizada na composicao do nome (ex.: `logs`).    |
| `versioning_status`  | string       | Nao         | Status do versionamento (`Enabled` ou `Suspended`). Padrao: `Enabled`.  |
| `additional_tags`    | map(string)  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.       |

## 3. Outputs

| Nome          | Descricao                            |
|---------------|----------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.              |
| `bucket_arn`  | ARN do bucket S3 criado.               |
| `bucket_id`   | ID do bucket S3 criado.                |

## 4. Exemplo de uso

```hcl
module "s3_logs" {
  source = "./exec-01/s3"

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
