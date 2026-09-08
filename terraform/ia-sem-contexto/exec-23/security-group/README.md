# Terraform AWS Security Group

Este módulo cria um Security Group na AWS dentro de uma VPC informada, com foco em segurança por padrão:
- Nenhuma regra de entrada (ingress) é criada por padrão (tudo negado).
- Regras de saída (egress) utilizam a regra padrão da AWS (tudo permitido) a menos que você as forneça explicitamente.

Requisitos:
- Terraform >= 1.3.0
- Provider AWS ~> 5.0

Como usar (exemplo simples):
- Cria um SG sem regras de ingress (negado) e com egress padrão da AWS (permitido).
- Ajuste a região e forneça o vpc_id.

Exemplo:
module "sg" {
  source  = "./este-modulo"
  region  = "us-east-1"
  vpc_id  = "vpc-0123abcd4567ef89"
  name    = "app-sg"
  tags = {
    Project     = "demo"
    Environment = "dev"
  }
}

Exemplo com regras de ingress e egress personalizadas:
module "sg" {
  source = "./este-modulo"
  region = "us-east-1"
  vpc_id = "vpc-0123abcd4567ef89"
  name   = "web-sg"

  # Permite HTTP/HTTPS de qualquer origem IPv4 e SSH apenas da sua rede
  ingress_rules = [
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      description      = "SSH restrito"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["203.0.113.0/24"]
    }
  ]

  # Egress restrito (exemplo): somente saída TCP 443 para qualquer IPv4
  egress_rules = [
    {
      description = "Saída HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Project     = "demo"
    Environment = "prod"
    Owner       = "platform-team"
  }
}

Variáveis principais:
- region (string): Região AWS. Padrão: us-east-1.
- vpc_id (string): ID da VPC onde o SG será criado. Obrigatório.
- name (string): Nome do SG. Padrão: secure-sg.
- description (string): Descrição do SG. Padrão: Security Group gerenciado pelo Terraform.
- ingress_rules (list(object)): Regras de entrada. Padrão: [] (nenhuma regra).
- egress_rules (list(object)|null): Regras de saída. Se null, mantém a regra padrão da AWS de liberar todo egress.
- revoke_rules_on_delete (bool): Revoga regras ao deletar o SG. Padrão: true.
- tags (map(string)): Tags adicionais.

Estrutura das regras de ingress/egress (cada item):
- description (opcional, string)
- from_port (number)
- to_port (number)
- protocol (string: tcp, udp, icmp, icmpv6, -1)
- cidr_blocks (opcional, list(string))
- ipv6_cidr_blocks (opcional, list(string))
- security_groups (opcional, list(string))
- prefix_list_ids (opcional, list(string))
Obs.: Cada regra deve conter pelo menos um destino/origem entre os campos acima.

Outputs:
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- ingress_rules_count
- egress_rules_count

Comandos úteis:
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Boas práticas:
- Mantenha o SSH fechado por padrão; quando necessário, restrinja a redes/cidrs específicos.
- Prefira restringir o egress conforme a necessidade da sua aplicação.
- Use tags para classificação dos recursos (ambiente, projeto, dono, custo).
