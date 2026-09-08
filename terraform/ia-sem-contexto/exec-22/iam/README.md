# Terraform AWS IAM Policy

Blueprint Terraform para criar uma IAM Managed Policy na AWS com configuração segura por padrão e parametrização flexível.

## Recursos

- Provider AWS configurável por região
- Criação de uma IAM Managed Policy
- Política gerada a partir de uma lista de statements
- Tags suportadas e mescladas com ManagedBy=Terraform
- Variáveis com validações
- Outputs úteis (ARN, nome, id, path e documento JSON)

## Uso rápido

1. Ajuste variáveis no arquivo variables.tf conforme necessário (ex.: região, nome, descrição, path, tags).
2. Opcionalmente, personalize os statements na variável "statements".
3. Execute os comandos:

terraform init -backend=false
terraform validate
terraform plan
terraform apply

## Exemplo de customização de variáveis

Exemplo mínimo alterando nome, descrição e região via linha de comando:

terraform plan \
  -var 'aws_region=us-east-1' \
  -var 'name=my-readonly-policy' \
  -var 'description=Read-only policy for common AWS services'

## Variáveis principais

- aws_region: Região AWS do provider.
- name: Nome explícito da policy. Se vazio, usa name_prefix.
- name_prefix: Prefixo para gerar o nome quando name está vazio.
- description: Descrição da policy.
- path: Caminho da policy (deve iniciar e finalizar com '/').
- tags: Mapa de tags.
- statements: Lista de statements para o documento da política.

Cada statement suporta:
- sid (opcional)
- effect: Allow ou Deny (padrão Allow)
- actions e/ou not_actions: lista de ações IAM
- resources e/ou not_resources: lista de ARNs de recursos
- conditions: lista de condições com test, variable e values

Observação: Esta blueprint cria uma policy gerenciada pela conta (IAM Managed Policy). Não inclui principals, pois são aplicáveis a políticas baseadas em recurso.

## Padrão seguro

Por padrão, a política criada permite apenas ações de leitura comuns (Describe/List/Get) em serviços amplamente utilizados e com resource="*". Ajuste os statements para o seu caso de uso, restringindo recursos por ARN quando possível.

## Outputs

- policy_arn: ARN da policy
- policy_name: Nome da policy
- policy_id: ID da policy
- policy_path: Caminho configurado
- policy_document_json: Documento JSON final da policy

## Requisitos

- Terraform >= 1.3.0
- Provider AWS >= 5.0 e < 6.0
- Credenciais AWS válidas configuradas no ambiente para aplicar (não necessárias para validação sintática)

## Notas

- Não há backend remoto configurado.
- Compatível com terraform fmt, terraform init -backend=false e terraform validate.
