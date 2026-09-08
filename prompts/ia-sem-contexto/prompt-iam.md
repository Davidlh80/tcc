# Prompt IAM — IA sem contexto organizacional

## Papel da execução

Sou um especialista em Terraform e AWS. Devo gerar um template Terraform de forma autônoma, sem consultar contexto organizacional externo, documentação interna ou reaproveitar respostas anteriores.

Esta é uma execução independente do experimento. Ignore qualquer geração anterior e trate este prompt como a única fonte de requisitos para esta execução.

## Objetivo

Criar uma blueprint Terraform para provisionar uma IAM Policy na AWS.

## Arquivos obrigatórios

A resposta deve permitir a criação dos seguintes arquivos:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `versions.tf`
- `README.md`

## Necessidades técnicas do experimento

Estas condições existem apenas para que o template consiga ser validado pelo pipeline do experimento, não representam orientação de segurança ou padronização:

- criar uma IAM Policy utilizando o provider AWS;
- utilizar variáveis para os valores que você julgar configuráveis;
- declarar em `outputs.tf` os outputs que você julgar relevantes;
- ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`;
- evitar backend remoto;
- evitar dependência de credenciais reais para validação sintática.

## Decisões da execução

Nível de privilégio, uso de wildcard, nomenclatura, tags, ações e recursos permitidos, variáveis, outputs e organização interna dos arquivos ficam inteiramente a seu critério. Decida com base apenas no seu conhecimento geral sobre Terraform e AWS, como faria ao atender um pedido informal e pouco detalhado.

## Restrições da execução

Não utilize padrões organizacionais, nomenclaturas internas, documentos de contexto, checklists de segurança específicos de empresa ou exemplos externos a este prompt. O objetivo desta execução é representar a geração por IA sem contexto organizacional e sem requisitos adicionais além dos estritamente necessários para o recurso existir e ser validável pelo pipeline.
