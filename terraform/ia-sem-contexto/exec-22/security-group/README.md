Blueprint Terraform: AWS Security Group

Visão geral
- Provisiona um Security Group (SG) em uma VPC específica.
- Regras de entrada (ingress) e saída (egress) são configuráveis via variáveis.
- Por padrão, nenhum ingress é permitido e o egress é liberado para todo tráfego (IPv4 e IPv6) se enable_default_egress=true.

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS ~> 5.0
- Uma VPC existente (informe vpc_id)

Como usar
1) Ajuste as variáveis (exemplo de terraform.tfvars):
region = "us-east-1"
vpc_id = "vpc-0123456789abcdef0"
name   = "sg-web"
description = "Web Security Group"
enable_default_egress = true

ingress_rules = [
  {
    description      = "Allow SSH from corp"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["203.0.113.0/24"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  },
  {
    description      = "Allow HTTPS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
]

# Se quiser controlar egress explicitamente (caso contrário, use enable_default_egress=true)
egress_rules = [
  {
    description      = "Allow outbound HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
  }
]

tags = {
  Environment = "dev"
  Owner       = "team-example"
}

2) Inicialize e valide
terraform init -backend=false
terraform validate
terraform plan

Variáveis principais
- region (string): Região AWS. Ex: us-east-1. Padrão: us-east-1.
- vpc_id (string): ID da VPC alvo. Obrigatório.
- name (string): Nome do SG. Padrão: sg-app.
- description (string): Descrição do SG. Padrão: Security Group managed by Terraform.
- revoke_rules_on_delete (bool): Revoga regras ao deletar. Padrão: true.
- enable_default_egress (bool): Cria egress allow-all quando egress_rules estiver vazio. Padrão: true.
- ingress_rules (list(object)): Regras de entrada. Exige pelo menos uma origem (cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, security_groups ou self=true).
- egress_rules (list(object)): Regras de saída. Exige pelo menos um destino (cidr_blocks, ipv6_cidr_blocks ou prefix_list_ids).
- tags (map(string)): Tags adicionais.

Boas práticas e observações
- Princípio do menor privilégio: forneça CIDRs e portas específicos. Evite 0.0.0.0/0 e ::/0 quando não necessários.
- O padrão não cria ingress; portanto, tráfego de entrada é negado até você declarar regras.
- Para egress, se preferir postura mais restritiva, defina enable_default_egress=false e especifique egress_rules conforme necessário.

Outputs
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- ingress_rule_count
- egress_rule_count
