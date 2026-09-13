# S3 Bucket

## Visao geral

Este template provisiona um bucket Amazon S3 seguindo os padroes organizacionais de nomenclatura, tags e seguranca. O bucket e criado com:

- nome composto no padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`;
- Public Access Block com as quatro flags habilitadas (bloqueio total de acesso publico);
- criptografia server-side com algoritmo AES256 (SSE-S3);
- bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- versionamento configuravel por variavel, com padrao `Enabled`;
- tags obrigatorias aplicadas automaticamente.

## Variaveis

| Nome               | Tipo         | Obrigatoria | Descricao                                                                 |
|--------------------|--------------|-------------|----------------------------------------------------------------------------|
| environment        | string       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                           |
| system             | string       | Sim         | Identificador do sistema/aplicacao dono do recurso.                       |
| region             | string       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.     |
| purpose            | string       | Sim         | Finalidade do bucket, usada na composicao do nome (ex.: `logs`).          |
| versioning_status  | string       | Nao         | Status do versionamento (`Enabled` ou `Suspended`). Padrao: `Enabled`.    |
| additional_tags    | map(string)  | Nao         | Tags adicionais a serem mescladas com as tags obrigatorias. Padrao: `{}`. |

## Outputs

| Nome        | Descricao                          |
|-------------|--------------------------------------|
| bucket_name | Nome do bucket S3 criado.           |
| bucket_arn  | ARN do bucket S3 criado.            |
| bucket_id   | ID do bucket S3 criado.             |

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
