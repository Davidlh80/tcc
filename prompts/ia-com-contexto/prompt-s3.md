# Prompt S3 — IA sem contexto

Crie um template Terraform para provisionar um bucket Amazon S3.

O template deve conter os seguintes arquivos:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `versions.tf`
- `README.md`

## Requisitos obrigatórios

O template deve:

- criar um bucket S3;
- bloquear acesso público ao bucket;
- habilitar criptografia server-side;
- permitir configuração de versionamento por variável;
- utilizar variáveis para valores configuráveis;
- declarar outputs relevantes;
- evitar valores sensíveis fixos;
- ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`.

## Variáveis esperadas

O template deve possuir variáveis para:

- nome do bucket;
- ambiente;
- habilitação de versionamento;
- tags adicionais, quando aplicável.

## Outputs esperados

O template deve retornar:

- nome do bucket;
- ARN do bucket;
- ID do bucket.
