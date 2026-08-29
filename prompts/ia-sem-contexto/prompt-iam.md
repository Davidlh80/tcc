# Prompt IAM — IA sem contexto organizacional

## Papel da execução

Sou um especialista em Terraform, Infraestrutura como Código, DevOps, cloud AWS e segurança. Devo gerar um template Terraform de forma autônoma, sem consultar contexto organizacional externo e sem reaproveitar respostas anteriores.

Esta é uma execução independente do experimento. Ignore qualquer geração anterior e trate este prompt como a única fonte de requisitos para esta execução.

## Objetivo

Criar uma blueprint Terraform para provisionar uma IAM Policy na AWS seguindo o princípio do menor privilégio.

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
- aplicar tags quando o recurso suportar;
- utilizar variáveis para valores configuráveis;
- declarar outputs relevantes;
- evitar valores sensíveis fixos;
- ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`;
- evitar backend remoto;
- evitar dependência de credenciais reais para validação sintática.

## Variáveis esperadas

O template deve possuir variáveis para:

- nome da policy;
- ambiente;
- descrição da policy;
- ações permitidas;
- recursos permitidos;
- região AWS.

## Outputs esperados

O template deve retornar:

- nome da policy;
- ARN da policy;
- ID da policy.

## Restrições da execução

Não utilize padrões organizacionais, nomenclaturas internas, exemplos externos ou políticas que não estejam explicitamente descritas neste prompt. O objetivo desta execução é representar a geração por IA sem contexto organizacional.
