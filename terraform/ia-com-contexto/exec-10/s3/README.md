# S3 Bucket - dev-tcc-s3-logs (exemplo)

## 1. Visao geral

Este modulo cria um bucket Amazon S3 seguindo os padroes internos da organizacao, contemplando:

- Nomenclatura padronizada no formato `<ambiente>-<sistema>-<recurso>-<finalidade>`;
- Bloqueio total de acesso publico (quatro flags do Public Access Block habilitadas);
- Criptografia server-side com algoritmo AES256 (SSE-S3);
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- Versionamento configuravel por variavel, com padrao `Enabled`;
- Tags obrigatorias da organizacao aplicadas automaticamente.

## 2. Variaveis

| Nome                | Tipo          | Obrigatoria | Descricao                                                                          |
|---------------------|---------------|-------------|--------------------------------------------------------------------------------------|
| `environment`        | `string`      | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                    |
| `system`              | `string`      | Nao         | Nome do sistema/projeto, usado na nomenclatura padrao. Padrao: `tcc`.               |
| `region`              | `string`      | Nao         | Regiao AWS onde o bucket sera criado. Padrao: `us-east-1`.                          |
| `additional_tags`     | `map(string)` | Nao         | Tags adicionais mescladas as tags obrigatorias da organizacao. Padrao: `{}`.        |
| `purpose`             | `string`      | Sim         | Finalidade do bucket, usada na nomenclatura padrao (ex.: `logs`).                   |
| `versioning_status`   | `string`      | Nao         | Status do versionamento do bucket (`Enabled` ou `Suspended`). Padrao: `Enabled`.     |

## 3. Outputs

| Nome           | Descricao                              |
|----------------|-----------------------------------------|
| `bucket_name`   | Nome do bucket S3 criado.               |
| `bucket_arn`    | ARN do bucket S3 criado.                |
| `bucket_id`     | ID (nome) do bucket S3 criado.          |

## 4. Exemplo de uso

```hcl
module "s3_logs" {
  source = "./s3"

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
