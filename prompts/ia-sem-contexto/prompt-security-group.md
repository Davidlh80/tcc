# Prompt Security Group — IA sem contexto (execução independente)

Esta é uma execução independente do experimento. Ignore qualquer geração anterior e trate este prompt como a única fonte de requisitos para esta execução.

Não mantenha contexto entre execuções. Cada execução deve ser autônoma, repetível e baseada apenas no que está descrito neste prompt.

Crie um template Terraform para provisionar um Security Group na AWS.

O template deve conter os seguintes arquivos:

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
- ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`.

## Variáveis esperadas

O template deve possuir variáveis para:

- nome do Security Group;
- descrição;
- ID da VPC;
- ambiente;
- regras de entrada;
- regras de saída;
- tags adicionais, quando aplicável.

## Outputs esperados

O template deve retornar:

- ID do Security Group;
- ARN do Security Group;
- nome do Security Group.

## Observação

O template deve ser gerado de forma isolada, sem reaproveitar resultados de execuções anteriores.