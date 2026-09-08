Blueprint Terraform — AWS Security Group

Descricao
- Provisiona um Security Group na AWS em uma VPC especificada.
- Seguranca por padrao: sem ingress (deny-all) e egress liberado para IPv4 (personalizavel).
- Totalmente configuravel por variaveis.

Requisitos
- Terraform >= 1.3.0
- Provider AWS ~> 5.0
- Uma VPC existente (forneca o vpc_id)

Entradas (principais)
- region (string): regiao AWS. Padrao: us-east-1
- vpc_id (string): ID da VPC (ex.: vpc-0123456789abcdef0)
- name (string): nome do Security Group. Padrao: app-sg
- description (string): descricao. Padrao: Managed by Terraform
- tags (map(string)): tags adicionais. Padrao: {}
- ingress_rules (list(object)): regras de entrada. Padrao: []
- egress_rules (list(object)): regras de saida. Padrao: permite todo trafego IPv4

Modelo de regra (ingress_rules/egress_rules)
- description (string, opcional)
- from_port (number)
- to_port (number)
- protocol (string) — ex.: tcp, udp, -1
- cidr_blocks (list(string), opcional)
- ipv6_cidr_blocks (list(string), opcional)
- security_groups (list(string), opcional)
- self (bool, opcional) — refere o proprio SG

Exemplo de uso rapido
- Defina variaveis (por exemplo em terraform.tfvars):
region = "us-east-1"
vpc_id = "vpc-0123456789abcdef0"
name   = "web-sg"
tags = {
  Environment = "dev"
  Owner       = "team"
}
ingress_rules = [
  {
    description      = "Allow HTTPS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = []
    self             = false
  },
  {
    description      = "Allow SSH from admin IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["198.51.100.10/32"]
    ipv6_cidr_blocks = []
    security_groups  = []
    self             = false
  }
]
egress_rules = [
  {
    description      = "Allow all outbound IPv4"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = []
    self             = false
  }
]

Execucao
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Saidas
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- ingress_rules_count
- egress_rules_count

Notas
- Evite abrir portas amplamente (ex.: 0.0.0.0/0) em ambientes de producao.
- Para regras IPv6, adicione ::/0 em ipv6_cidr_blocks conforme necessario.
