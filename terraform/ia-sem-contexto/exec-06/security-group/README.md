Terraform AWS Security Group

Visao geral
- Este template cria um Security Group na AWS, associado a uma VPC informada por variavel.
- As regras de entrada e saida sao configuraveis via variaveis.
- Padroes seguros: sem ingress padrao; egress liberado por padrao (customizavel).
- Nao utiliza backend remoto.

Requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Uma VPC existente (vpc_id obrigatorio)

Como usar (exemplo simples)
1) Ajuste as variaveis (exemplo):
region = "us-east-1"
vpc_id = "vpc-0123456789abcdef0"
name   = "app-sg"
description = "Security Group da aplicacao"
ingress_rules = [
  {
    description      = "SSH admin"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["203.0.113.0/24"]
    ipv6_cidr_blocks = []
    security_groups  = []
    self             = false
  },
  {
    description      = "HTTP publico"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_groups  = []
    self             = false
  }
]
# egress_rules possui por padrao saida liberada para IPv4 e IPv6; personalize se desejar.
tags = {
  Environment = "dev"
  Project     = "sample"
}

2) Execucao:
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Estrutura das variaveis de regras
- Cada regra (ingress_rules ou egress_rules) aceita:
  - description (string, opcional)
  - from_port (number, obrigatorio para protocolos baseados em porta; para -1 use 0)
  - to_port (number, obrigatorio para protocolos baseados em porta; para -1 use 0)
  - protocol (string; exemplos: tcp, udp, icmp, -1 para todos)
  - cidr_blocks (lista de CIDRs IPv4)
  - ipv6_cidr_blocks (lista de CIDRs IPv6)
  - prefix_list_ids (lista de IDs de prefix-list)
  - security_groups (lista de IDs de SG como origem/destino)
  - self (bool; true para referenciar o proprio SG)

Boas praticas
- Restringir ingress a apenas as portas e origens necessarias.
- Rever se a politica de egress padrao (liberar tudo) atende seu caso; restrinja conforme necessario.
- Utilizar tags para facilitar governanca e custos.

Outputs
- security_group_id: ID do SG
- security_group_arn: ARN do SG
- security_group_name: Nome do SG
- security_group_vpc_id: VPC associada
- owner_id: ID da conta proprietaria
- ingress_rules_count: Contagem de regras de entrada
- egress_rules_count: Contagem de regras de saida

Observacoes
- Este template evita uso de credenciais reais e backend remoto para facilitar validacao sintatica (terraform validate) e inicializacao local (terraform init -backend=false).
