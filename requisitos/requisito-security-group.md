# Requisitos do Template Security Group

O template deve criar regras de rede explícitas e justificáveis.

## Obrigatórios

- Criar um Security Group;
- permitir configuração de VPC;
- declarar regras de entrada e saída;
- evitar abertura irrestrita desnecessária;
- aplicar tags obrigatórias;
- declarar outputs relevantes.

## Variáveis esperadas

Nome do Security Group, ID da VPC, ambiente, portas permitidas e CIDRs permitidos.

## Outputs esperados

ID, ARN e nome do Security Group.
