Visão geral do recurso
Este template provisiona um Security Group na AWS seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-sg-<finalidade>
- Tags obrigatórias aplicadas a todos os recursos
- Regras de segurança:
  - Proíbe 0.0.0.0/0 (e ::/0) em qualquer porta além da 443/tcp (ingresso e egresso)
  - Exige descrição em todas as regras de entrada e saída
  - Egress declarado explicitamente (não há liberação irrestrita por padrão)
- Parâmetros configuráveis via variáveis, com validações
- Compatível com terraform init -backend=false e terraform validate

Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment | string | Sim | Ambiente do recurso. Valores permitidos: dev, hml, prd.
- system | string | Sim | Nome do sistema (minúsculo, números e hífens).
- region | string | Sim | Região AWS (ex.: us-east-1).
- additional_tags | map(string) | Não | Tags adicionais a aplicar junto às obrigatórias (sem sobrescrever).
- vpc_id | string | Sim | ID da VPC onde o Security Group será criado.
- security_group_name | string | Sim | Nome do Security Group seguindo <environment>-<system>-sg-<finalidade>.
- security_group_description | string | Sim | Descrição do Security Group.
- ingress_rules | list(object) | Não | Regras de entrada com descrição obrigatória. 0.0.0.0/0 ou ::/0 somente permitido para 443/tcp.
- egress_rules | list(object) | Sim | Regras de saída explícitas com descrição obrigatória. 0.0.0.0/0 ou ::/0 somente permitido para 443/tcp.

Estrutura dos objetos de regra (ingress_rules e egress_rules):
- description (string) - obrigatório
- protocol (string) - ex.: tcp, udp, icmp, -1
- from_port (number)
- to_port (number)
- cidr_blocks (list(string)) - opcional
- ipv6_cidr_blocks (list(string)) - opcional

Tabela de outputs (nome, descrição)
- security_group_name | Nome do Security Group criado.
- security_group_arn | ARN do Security Group criado.
- security_group_id | ID do Security Group criado.

Exemplo de uso do módulo/recurso
module "sg_example" {
  source = "."

  region      = "us-east-1"
  environment = "dev"
  system      = "tcc"
  vpc_id      = "vpc-0123456789abcdef0"

  # Nome seguindo o padrão <environment>-<system>-sg-<finalidade>
  security_group_name        = "dev-tcc-sg-web"
  security_group_description = "Security Group para workload web (padrão corporativo)."

  # Regras de entrada (ex.: HTTPS público)
  ingress_rules = [
    {
      description      = "Permitir HTTPS público"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  # Regras de saída explícitas (ex.: saída somente para porta 443 para a Internet)
  egress_rules = [
    {
      description      = "Permitir saída HTTPS para Internet"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  additional_tags = {
    Application = "sample-app"
    Squad       = "platform"
  }
}

Saída esperada
- security_group_name, security_group_arn, security_group_id após a aplicação.
