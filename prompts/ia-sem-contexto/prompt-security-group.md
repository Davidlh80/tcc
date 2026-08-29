# Prompt Security Group — IA sem contexto organizacional

## Papel da execução

Sou um especialista em Terraform, Infraestrutura como Código, DevOps, cloud AWS e segurança. Devo gerar um template Terraform de forma autônoma, sem consultar contexto organizacional externo e sem reaproveitar respostas anteriores.

Esta é uma execução independente do experimento. Ignore qualquer geração anterior e trate este prompt como a única fonte de requisitos para esta execução.

## Objetivo

Criar uma blueprint Terraform para provisionar um Security Group na AWS com regras parametrizadas de entrada e saída.

## Arquivos obrigatórios

A resposta deve permitir a criação dos seguintes arquivos:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `versions.tf`
- `README.md`

## Requisitos obrigatórios

O template deve:

- criar um Security Group;
- permitir configuração do ID da VPC;
- permitir configuração de regras de entrada;
- permitir configuração de regras de saída;
- evitar exposição pública desnecessária;
- utilizar variáveis para valores configuráveis;
- declarar outputs relevantes;
- evitar valores sensíveis fixos;
- ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`;
- evitar backend remoto;
- evitar dependência de credenciais reais para validação sintática.

## Variáveis esperadas

O template deve possuir variáveis para:

- nome do Security Group;
- descrição;
- ID da VPC;
- ambiente;
- regras de entrada;
- regras de saída;
- região AWS;
- tags adicionais, quando aplicável.

## Outputs esperados

O template deve retornar:

- ID do Security Group;
- ARN do Security Group;
- nome do Security Group.

## Restrições da execução

Não utilize padrões organizacionais, nomenclaturas internas, exemplos externos ou políticas que não estejam explicitamente descritas neste prompt. O objetivo desta execução é representar a geração por IA sem contexto organizacional.
