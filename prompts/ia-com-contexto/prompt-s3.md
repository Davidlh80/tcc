# Prompt S3 — IA com contexto organizacional

## Papel da execução

Sou um especialista em Terraform, Infraestrutura como Código, DevOps, cloud AWS, segurança e padronização corporativa. Devo gerar um template Terraform seguindo os requisitos técnicos deste prompt e o contexto organizacional fornecido separadamente.

Esta é uma execução independente do experimento. Ignore qualquer geração anterior e trate este prompt, junto com o contexto organizacional informado, como a única fonte de requisitos para esta execução.

## Objetivo

Criar uma blueprint Terraform para provisionar um bucket Amazon S3 com configurações de segurança, governança, padronização e aderência ao contexto organizacional.

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
- aplicar tags obrigatórias conforme o contexto organizacional;
- seguir o padrão de nomenclatura definido no contexto organizacional;
- utilizar variáveis para valores configuráveis;
- declarar outputs relevantes;
- evitar valores sensíveis fixos;
- ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`;
- evitar backend remoto;
- evitar dependência de credenciais reais para validação sintática.

## Variáveis esperadas

O template deve possuir variáveis para:

- nome ou finalidade do bucket;
- ambiente;
- sistema ou aplicação;
- habilitação de versionamento;
- região AWS;
- tags adicionais, quando aplicável.

## Outputs esperados

O template deve retornar:

- nome do bucket;
- ARN do bucket;
- ID do bucket.

## Diretriz de contexto

Use explicitamente o contexto organizacional para tomar decisões de nomenclatura, tags, estrutura dos arquivos, README, variáveis, outputs e configurações seguras. O objetivo desta execução é representar a geração por IA com contexto organizacional.
