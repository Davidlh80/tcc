Terraform AWS Security Group

Resumo
- Provisiona um Security Group na AWS com configuracoes seguras por padrao.
- Sem regras de entrada por padrao (deny-all inbound).
- Libera todo egress por padrao (IPv4 e IPv6), configuravel via variaveis.

Requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS disponiveis no ambiente (por exemplo, via AWS_PROFILE, AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY), apenas necessarias no apply.

Variaveis principais
- region (string): Regiao AWS. Default: us-east-1
- vpc_id (string): ID da VPC onde o Security Group sera criado. Obrigatorio.
- name (string): Nome do Security Group. Default: tf-secgroup
- description (string): Descricao do Security Group. Default: Managed by Terraform - Security Group
- tags (map(string)): Tags adicionais.
- ingress_cidr_rules (list(object)): Regras de entrada baseadas em CIDRs. Default: []
- ingress_sg_rules (list(object)): Regras de entrada referenciando SGs. Default: []
- egress_cidr_rules (list(object)): Regras de saida baseadas em CIDRs. Default: Allow all (0.0.0.0/0 e ::/0)
- egress_sg_rules (list(object)): Regras de saida referenciando SGs. Default: []

Exemplo de uso (arquivo terraform.tfvars sugerido)
region = "us-east-1"
vpc_id = "vpc-0123456789abcdef0"
name   = "example-web-sg"
tags = {
  Environment = "dev"
  Project     = "demo"
}

ingress_cidr_rules = [
  {
    description      = "HTTP IPv4 e IPv6 de qualquer origem"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  },
  {
    description      = "SSH somente da rede corporativa"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/8"]
    ipv6_cidr_blocks = []
  }
]

ingress_sg_rules = [
  {
    description              = "Aplicacao para DB"
    from_port                = 5432
    to_port                  = 5432
    protocol                 = "tcp"
    source_security_group_id = "sg-0123456789abcdef0"
    self                     = false
  }
]

# Mantem o padrao de egress liberado (pode customizar se desejar)
# egress_cidr_rules e egress_sg_rules podem ser redefinidos

Comandos basicos
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Outputs
- security_group_id: ID do SG
- security_group_arn: ARN do SG
- security_group_name: Nome do SG
- security_group_vpc_id: ID da VPC
- ingress_rules_count: Total de regras de ingress
- egress_rules_count: Total de regras de egress
- security_group_tags: Tags aplicadas
