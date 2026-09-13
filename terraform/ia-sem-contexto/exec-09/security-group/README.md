# Security Group (AWS) via Terraform

Blueprint para provisionamento de um Security Group na AWS, com a VPC de destino configurável por variável. Não cria nem depende da VPC padrão da conta — o `vpc_id` deve apontar para uma VPC já existente (por exemplo, uma VPC de teste criada pelo próprio ambiente).

## Comportamento padrão

- Nenhuma regra de entrada é criada por padrão (`ingress_rules = []`), seguindo o princípio de menor privilégio.
- Uma regra de saída liberando todo o tráfego (`0.0.0.0/0`) é criada por padrão, podendo ser substituída via `egress_rules`.
- O nome do Security Group é gerado a partir de `name_prefix`, evitando colisões de nome em criações concorrentes.

## Inputs

- region (string, opcional, padrão "us-east-1"): região AWS onde o recurso será criado.
- vpc_id (string, obrigatório): ID da VPC existente onde o Security Group será provisionado. Deve seguir o padrão "vpc-xxxxxxxx".
- name_prefix (string, opcional, padrão "app"): prefixo usado para nomear o Security Group.
- description (string, opcional): descrição do Security Group.
- ingress_rules (list(object), opcional, padrão []): lista de regras de entrada. Cada item define description, from_port, to_port, protocol e cidr_blocks.
- egress_rules (list(object), opcional): lista de regras de saída, com a mesma estrutura de ingress_rules. Por padrão libera todo o tráfego de saída.
- tags (map(string), opcional, padrão {}): tags adicionais aplicadas ao recurso.

## Outputs

- security_group_id: ID do Security Group criado.
- security_group_arn: ARN do Security Group criado.
- security_group_name: nome efetivo do Security Group.
- vpc_id: ID da VPC associada ao Security Group.
- owner_id: ID da conta AWS proprietária do recurso.

## Exemplo de uso

Defina vpc_id apontando para a VPC de teste e, se necessário, informe ingress_rules com as portas e origens desejadas, como uma regra HTTPS (porta 443) liberada apenas para um bloco CIDR específico da rede interna, em vez de 0.0.0.0/0, para manter um padrão seguro.

## Validação

Este módulo foi projetado para ser validado sem credenciais reais e sem backend remoto, através dos comandos terraform init -backend=false e terraform validate.
