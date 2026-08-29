# Prompt IAM — IA sem contexto (execução independente)

Esta é uma execução independente do experimento. Ignore qualquer geração anterior e trate este prompt como a única fonte de requisitos para esta execução.

Não mantenha contexto entre execuções. Cada execução deve ser autônoma, repetível e baseada apenas no que está descrito neste prompt.

Crie um template Terraform para provisionar uma política IAM na AWS.

O template deve conter os seguintes arquivos:

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
- ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`.

## Variáveis esperadas

O template deve possuir variáveis para:

- nome da policy;
- ambiente;
- descrição da policy;
- ações permitidas;
- recursos permitidos.

## Outputs esperados

O template deve retornar:

- nome da policy;
- ARN da policy;
- ID da policy.

## Observação

O template deve ser gerado de forma isolada, sem reaproveitar resultados de execuções anteriores.