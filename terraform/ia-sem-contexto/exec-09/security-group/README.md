Blueprint Terraform — AWS Security Group

Descrição
- Provisiona um Security Group na AWS dentro de uma VPC específica.
- Padrões seguros: sem regras de ingress por padrão; egress liberado para IPv4 e IPv6.
- Totalmente configurável via variáveis.

Arquivos
- main.tf: Provider, recurso aws_security_group e lógica de regras dinâmicas.
- variables.tf: Variáveis de configuração com validações.
- outputs.tf: Saídas úteis.
- versions.tf: Versões mínimas do Terraform e provider AWS.
- README.md: Instruções de uso.

Pré-requisitos
- Terraform >= 1.5.0
- Provider AWS ~> 5.x
- Credenciais AWS configuradas no ambiente (ex.: variáveis de ambiente ou perfil do AWS CLI)

Como usar
1) Ajuste as variáveis conforme necessário (via -var, .tfvars ou variáveis de ambiente).
2) Execute:
   terraform init -backend=false
   terraform validate
   terraform plan -var 'vpc_id=vpc-xxxxxxxx'
   terraform apply -var 'vpc_id=vpc-xxxxxxxx'

Variáveis principais
- aws_region (string): Região AWS. Padrão: us-east-1
- vpc_id (string): ID da VPC onde o SG será criado. Obrigatória.
- name (string): Nome do SG. Padrão: tf-sg
- description (string): Descrição do SG. Padrão: Security Group gerenciado por Terraform
- tags (map(string)): Tags adicionais. Padrão: {}
- ingress_rules (list(object)): Regras de entrada. Padrão: []
- egress_rules (list(object)): Regras de saída. Padrão: permite todo tráfego para 0.0.0.0/0 e ::/0

Formato das regras (ingress_rules e egress_rules)
Cada item da lista é um objeto com os campos:
- description (string, opcional)
- from_port (number)
- to_port (number)
- protocol (string): um de -1, tcp, udp, icmp, icmpv6
- cidr_blocks (list(string), opcional)
- ipv6_cidr_blocks (list(string), opcional)
- prefix_list_ids (list(string), opcional)
- self (bool, opcional)

Exemplos

Exemplo 1: Somente SSH IPv4 de um bloco específico
vars:
  vpc_id = "vpc-0123456789abcdef0"
  name   = "example-ssh"
  ingress_rules = [
    {
      description = "SSH de admin"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["203.0.113.0/24"]
    }
  ]

Exemplo 2: HTTP/HTTPS públicos e saída padrão
vars:
  vpc_id = "vpc-0123456789abcdef0"
  name   = "web-sg"
  ingress_rules = [
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0", "::/0"]
    },
    {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0", "::/0"]
    }
  ]

Boas práticas
- Mantenha ingress o mais restritivo possível (evite 0.0.0.0/0 a menos que necessário).
- Use IPv6 apenas quando necessário e com regras específicas.
- Versione um tfvars por ambiente para padronizar entradas.

Outputs
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- security_group_tags
- ingress_rules_input
- egress_rules_input
