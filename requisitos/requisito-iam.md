# Requisitos do Template IAM

O template deve criar uma configuração de permissões seguindo o princípio do menor privilégio.

## Obrigatórios

- Criar uma policy IAM;
- criar uma role IAM e anexar a policy a ela (a policy não deve ficar solta, sem nenhum principal associado);
- definir uma trust policy (assume role policy) para a role, restrita a um principal configurável (ex.: um serviço AWS específico), sem permitir qualquer conta ou principal (`"*"` ou `AWS: "*"`);
- evitar permissões administrativas e wildcard amplo quando possível;
- utilizar nomes padronizados;
- aplicar tags quando suportado;
- declarar outputs relevantes.

## Variáveis esperadas

Nome da policy, nome da role, ambiente, principal de confiança (assume role), ações permitidas e recursos permitidos.

## Outputs esperados

Nome, ARN e ID da policy; nome e ARN da role.
