# Security Group (AWS) — Blueprint Terraform

Blueprint Terraform para provisionar um Security Group na AWS, associado a uma VPC configurável via variável, com regras explícitas de entrada e saída.

## Objetivo

Criar um aws_security_group dentro de uma VPC informada pelo usuário (não depende da VPC padrão da conta), com regras de ingress/egress declaradas explicitamente por variável, tags aplicadas e outputs relevantes.

## Recursos criados

- aws_security_group.this

## Requisitos

- Terraform >= 1.5.0
- Provider AWS >= 5.0, < 6.0
- Uma VPC previamente existente (ID informado via variável vpc_id)

## Variáveis principais

- aws_region: região AWS utilizada pelo provider (default: us-east-1).
- vpc_id: ID da VPC onde o Security Group será criado. Obrigatório, validado por regex no formato vpc-xxxxxxxx.
- name: nome do Security Group (default: sg-app).
- description: descrição do Security Group.
- ingress_rules: lista de objetos com description, from_port, to_port, protocol e cidr_blocks. O default fornecido é apenas um exemplo (HTTPS a partir de uma rede interna) e deve ser ajustado conforme a necessidade real do workload.
- egress_rules: lista de objetos no mesmo formato de ingress_rules. O default fornecido libera apenas HTTPS (porta 443) de saída.
- tags: mapa de tags adicionais aplicadas ao recurso.

## Outputs

- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- security_group_ingress_rules
- security_group_egress_rules

## Uso

Exemplo de chamada do módulo informando a VPC de teste e regras customizadas:

module.security_group:
  source  = "./"
  vpc_id  = "vpc-0123456789abcdef0"
  name    = "sg-exemplo"

  ingress_rules = [
    {
      description = "Permite SSH apenas da rede de administracao"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["192.168.100.0/24"]
    }
  ]

  egress_rules = [
    {
      description = "Permite HTTPS de saida"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "test"
  }

## Validação

Este blueprint foi escrito para ser validado sem credenciais reais e sem backend remoto:

1. terraform init -backend=false
2. terraform validate
3. terraform fmt -check

## Boas práticas de segurança aplicadas

- Nenhuma regra abre todas as portas/protocolos para 0.0.0.0/0 por padrão.
- O ingress padrão é restrito a uma faixa de rede interna, não à internet.
- O egress padrão é restrito a uma porta específica (443), em vez de liberar todo o tráfego de saída.
- O ID da VPC é validado via expressão regular para evitar valores inválidos ou vazios.
- Todas as regras são declaradas de forma explícita via variáveis tipadas (list(object(...))), facilitando auditoria e revisão.
