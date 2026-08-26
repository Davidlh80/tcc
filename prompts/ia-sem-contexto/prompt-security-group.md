# Prompt Security Group — IA com contexto organizacional

Crie um template Terraform para provisionar um Security Group na AWS.

Além dos requisitos técnicos abaixo, o template deve seguir o contexto organizacional fornecido separadamente pelo experimento.

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
- incluir descrição clara nas regras;
- seguir o padrão de nomenclatura definido no contexto organizacional;
- aplicar tags obrigatórias conforme o contexto organizacional;
- utilizar variáveis para valores configuráveis;
- declarar outputs relevantes;
- evitar valores sensíveis fixos;
- ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`.

## Variáveis esperadas

O template deve possuir variáveis para:

- nome ou finalidade do Security Group;
- descrição;
- ID da VPC;
- ambiente;
- sistema ou aplicação;
- regras de entrada;
- regras de saída;
- tags adicionais, quando aplicável.

## Outputs esperados

O template deve retornar:

- ID do Security Group;
- ARN do Security Group;
- nome do Security Group.

## Observação

O template deve priorizar segurança, padronização e aderência ao contexto organizacional.
