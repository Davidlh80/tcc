# Prompt S3 — IA sem contexto organizacional

## Papel da execução

Sou um especialista em Terraform, Infraestrutura como Código, DevOps, cloud AWS e segurança. Devo gerar um template Terraform de forma autônoma, sem consultar contexto organizacional externo e sem reaproveitar respostas anteriores.

Esta é uma execução independente do experimento. Ignore qualquer geração anterior e trate este prompt como a única fonte de requisitos para esta execução.

## Objetivo

Criar uma blueprint Terraform para provisionar um bucket Amazon S3 com configurações básicas de segurança, organização e parametrização.

## Arquivos obrigatórios

A resposta deve permitir a criação dos seguintes arquivos:

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
- ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`;
- evitar backend remoto;
- evitar dependência de credenciais reais para validação sintática.

## Variáveis esperadas

O template deve possuir variáveis para:

- nome do bucket;
- ambiente;
- habilitação de versionamento;
- região AWS;
- tags adicionais, quando aplicável.

## Outputs esperados

O template deve retornar:

- nome do bucket;
- ARN do bucket;
- ID do bucket.

## Restrições da execução

Não utilize padrões organizacionais, nomenclaturas internas, exemplos externos ou políticas que não estejam explicitamente descritas neste prompt. O objetivo desta execução é representar a geração por IA sem contexto organizacional.
