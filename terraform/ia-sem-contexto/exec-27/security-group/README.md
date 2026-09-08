# Terraform AWS Security Group

Este template cria um Security Group na AWS com regras de entrada e saída configuráveis via variáveis.

Requisitos
- Terraform >= 1.0.0
- Provider AWS ~> 5.x

Entradas
- region (string): Região AWS. Padrão: us-east-1.
- vpc_id (string): ID da VPC onde o Security Group será criado. Obrigatório.
- name (string): Nome do Security Group. Padrão: secure-sg.
- description (string): Descrição do Security Group. Padrão: Security Group managed by Terraform.
- ingress_rules (list(object)): Lista de regras de entrada. Padrão: [] (nenhuma entrada permitida).
- egress_rules (list(object)): Lista de regras de saída. Padrão: regra que permite todo tráfego IPv4 de saída.
- tags (map(string)): Tags adicionais. Padrão: {}.

Formato das regras (ingress_rules e egress_rules)
Cada regra é um objeto com os campos:
- description (string)
- protocol (string) — por exemplo: tcp, udp, icmp, -1 para qualquer
- from_port (number)
- to_port (number)
- cidr_blocks (list(string)) — por exemplo: ["10.0.0.0/16"]
- ipv6_cidr_blocks (list(string)) — por exemplo: ["::/0"]
- prefix_list_ids (list(string)) — por exemplo: ["pl-12345678"]

Observações
- Por padrão, nenhuma regra de entrada é criada.
- Por padrão, é criada uma regra de saída permitindo todo tráfego IPv4. Ajuste egress_rules conforme sua política.
- Caso prefira remover o “allow all egress”, defina egress_rules como uma lista vazia [] e adicione apenas as regras específicas necessárias.

Exemplo de uso
module "sg_example" {
  source = "./."

  region = "us-east-1"
  vpc_id = "vpc-0123456789abcdef0"
  name   = "example-sg"

  # Permite SSH de um bloco corporativo e HTTP/HTTPS público
  ingress_rules = [
    {
      description       = "SSH from corp"
      protocol          = "tcp"
      from_port         = 22
      to_port           = 22
      cidr_blocks       = ["203.0.113.0/24"]
      ipv6_cidr_blocks  = []
      prefix_list_ids   = []
    },
    {
      description       = "HTTP from anywhere"
      protocol          = "tcp"
      from_port         = 80
      to_port           = 80
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      prefix_list_ids   = []
    },
    {
      description       = "HTTPS from anywhere"
      protocol          = "tcp"
      from_port         = 443
      to_port           = 443
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      prefix_list_ids   = []
    }
  ]

  # Exemplo de egress mínimo: apenas saída para a VPC
  # egress_rules = [
  #   {
  #     description       = "Egress to VPC CIDR"
  #     protocol          = "-1"
  #     from_port         = 0
  #     to_port           = 0
  #     cidr_blocks       = ["10.0.0.0/16"]
  #     ipv6_cidr_blocks  = []
  #     prefix_list_ids   = []
  #   }
  # ]

  tags = {
    Environment = "dev"
    Project     = "example"
  }
}

Saídas
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- ingress_rules_count
- egress_rules_count

Comandos úteis
- terraform init -backend=false
- terraform validate
- terraform plan
