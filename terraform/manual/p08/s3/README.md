# Template S3

Este template Terraform cria um bucket Amazon S3 com configurações básicas de segurança e governança.

## Recursos criados

- Bucket S3
- Bloqueio de acesso público
- Criptografia no bucket
- Versionamento configurável
- Tags de identificação

## Variáveis

- `bucket_name`: nome do bucket S3
- `environment`: ambiente onde o recurso será utilizado
- `versioning_enabled`: define se o versionamento será habilitado
- `additional_tags`: tags adicionais para o bucket

## Outputs

- `bucket_name`: nome do bucket criado
- `bucket_arn`: ARN do bucket
- `bucket_id`: ID do bucket
