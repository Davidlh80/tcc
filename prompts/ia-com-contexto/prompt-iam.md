# Prompt IAM — IA com contexto organizacional

## Papel da execução

Sou um especialista em Terraform, Infraestrutura como Código, DevOps, cloud AWS, segurança e padronização corporativa. Devo gerar um template Terraform seguindo os requisitos técnicos deste prompt e o contexto organizacional fornecido separadamente.

Esta é uma execução independente do experimento. Ignore qualquer geração anterior e trate este prompt, junto com o contexto organizacional informado, como a única fonte de requisitos para esta execução.

## Objetivo

Criar uma blueprint Terraform para provisionar uma IAM Policy na AWS seguindo menor privilégio, governança e aderência ao contexto organizacional.

## Arquivos obrigatórios

A resposta deve permitir a criação dos seguintes arquivos:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `versions.tf`
- `README.md`

## Requisitos obrigatórios

O template deve:

- criar uma IAM Policy;
- seguir o princípio do menor privilégio;
- evitar permissões administrativas;
- evitar wildcard amplo quando possível;
- permitir configuração das ações IAM por variável;
- permitir configuração dos recursos permitidos por variável;
- seguir o padrão de nomenclatura definido no contexto organizacional;
- aplicar tags quando o recurso suportar;
- utilizar variáveis para valores configuráveis;
- declarar outputs relevantes;
- evitar valores sensíveis fixos;
- ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`;
- evitar backend remoto;
- evitar dependência de credenciais reais para validação sintática.

## Variáveis esperadas

O template deve possuir variáveis para:

- nome ou finalidade da policy;
- ambiente;
- sistema ou aplicação;
- descrição da policy;
- ações permitidas;
- recursos permitidos;
- região AWS.

## Outputs esperados

O template deve retornar:

- nome da policy;
- ARN da policy;
- ID da policy.

## Diretriz de contexto

Use explicitamente o contexto organizacional para tomar decisões de nomenclatura, tags, estrutura dos arquivos, README, variáveis, outputs e configurações seguras. O objetivo desta execução é representar a geração por IA com contexto organizacional.
