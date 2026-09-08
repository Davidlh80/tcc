Blueprint Terraform — AWS Security Group

Descrição
- Este template cria um Security Group na AWS com foco em configurações seguras por padrão.
- Por padrão, não há regras de ingress nem egress (zero trust). Defina explicitamente as regras necessárias.
- Compatível com terraform init -backend=false e terraform validate.

Recursos
- aws_security_group com:
  - vpc_id parametrizável
  - revoke_rules_on_delete habilitado por padrão
  - Regras de ingress/egress definidas via variáveis
  - Tags customizáveis e tag Name gerada a partir do nome do SG

Variáveis principais
- aws_region (string): Região AWS. Padrão: us-east-1
- vpc_id (string): ID da VPC onde o SG será criado. Obrigatório.
- name (string): Nome do SG. Padrão: sg-app
- description (string): Descrição do SG. Padrão: Security Group managed by Terraform
- revoke_rules_on_delete (bool): Revogar regras na destruição. Padrão: true
- ingress_rules (list(object)): Lista de regras de entrada. Padrão: []
- egress_rules (list(object)): Lista de regras de saída. Padrão: []
- tags (map(string)): Tags adicionais. Padrão: {}

Formato das regras (ingress_rules e egress_rules)
Cada item da lista deve seguir a estrutura:
- description (opcional, string)
- protocol (string, ex: "tcp", "udp", "icmp", "-1" para todos)
- from_port (number)
- to_port (number)
- cidr_blocks (opcional, list(string), ex: ["10.0.0.0/16"])
- ipv6_cidr_blocks (opcional, list(string), ex: ["::/0"])
- prefix_list_ids (opcional, list(string))
- security_groups (opcional, list(string) — IDs de SG de origem)
- self (opcional, bool — se true, referencia o próprio SG)

Observações
- Para protocol = "-1" (todos os protocolos), use from_port = 0 e to_port = 0 conforme prática comum da AWS.
- Em IPv6, use "::/0" para equivalente a 0.0.0.0/0.
- As validações básicas de portas (0–65535) e to_port >= from_port já estão incluídas.

Exemplo de uso (valores em terraform.tfvars)
aws_region = "us-east-1"
vpc_id     = "vpc-0123456789abcdef0"
name       = "sg-web"
description = "Web SG"

ingress_rules = [
  {
    description      = "Allow HTTP"
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  },
  {
    description      = "Allow HTTPS"
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
]

egress_rules = [
  {
    description      = "Allow all egress (use com cautela)"
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
]

tags = {
  Environment = "dev"
  Project     = "example"
}

Comandos úteis
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Saídas (outputs)
- security_group_id: ID do SG
- security_group_arn: ARN do SG
- security_group_name: Nome do SG
- security_group_vpc_id: VPC associada
- ingress_rule_count: Quantidade de regras de entrada
- egress_rule_count: Quantidade de regras de saída
