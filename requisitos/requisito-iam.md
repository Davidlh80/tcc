# Requisitos do Template IAM

O template deve criar uma configuração de permissões seguindo o princípio do menor privilégio.

## Obrigatórios

- Criar uma policy IAM;
- evitar permissões administrativas e wildcard amplo quando possível;
- utilizar nomes padronizados;
- aplicar tags quando suportado;
- declarar outputs relevantes.

## Variáveis esperadas

Nome da policy, ambiente, ações permitidas e recursos permitidos.

## Outputs esperados

Nome, ARN e ID da policy.
