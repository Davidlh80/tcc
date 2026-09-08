Security Group AWS — Terraform

Visão geral
- Este template cria um Security Group em uma VPC específica e permite gerenciar regras de ingress e egress de forma declarativa.
- Padrões seguros: nenhum ingress por padrão; egress liberado por padrão (pode ser ajustado via variável).

Requisitos
- Terraform >= 1.0.0
- Provider AWS >= 4.0
- Uma VPC existente (forneça o ID via variável vpc_id)

Variáveis principais
- region (string): Região AWS. Padrão: us-east-1.
- vpc_id (string): ID da VPC onde o SG será criado. Obrigatório.
- name (string): Nome do Security Group. Padrão: sg-managed.
- description (string): Descrição do SG. Padrão: Security group managed by Terraform.
- revoke_rules_on_delete (bool): Revoga regras antes de apagar o SG. Padrão: true.
- tags (map(string)): Tags adicionais para o SG. Padrão: {}.
- ingress_rules (list(object)): Lista de regras de entrada.
- egress_rules (list(object)): Lista de regras de saída. Padrão permite todo tráfego de saída (IPv4 e IPv6).

Estrutura de regra (ingress_rules e egress_rules)
- description (string): Descrição da regra.
- from_port (number), to_port (number): Portas (0-65535).
- protocol (string): tcp, udp, icmp, icmpv6, ou -1.
- cidr_blocks (list(string)): Lista de CIDRs IPv4 de origem/destino.
- ipv6_cidr_blocks (list(string)): Lista de CIDRs IPv6 de origem/destino.
- security_groups (list(string)): IDs de Security Groups de origem/destino (um recurso por item será criado).
- self (bool): Verdadeiro para referenciar o próprio SG como origem/destino.

Exemplo de uso (root module)
Arquivos no mesmo diretório do template. Ajuste o vpc_id e, se desejar, as regras.

Exemplo simples: permitir SSH do seu IP e HTTP de qualquer lugar; egress padrão já incluso.
terraform init -backend=false
terraform validate
terraform plan -var='vpc_id=vpc-0123456789abcdef0' -var='ingress_rules=[
  {
    description      = "SSH from my IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["203.0.113.10/32"]
    ipv6_cidr_blocks = []
    security_groups  = []
    self             = false
  },
  {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_groups  = []
    self             = false
  }
]'

Exemplo com origem em outro SG e self
terraform plan -var='vpc_id=vpc-0123456789abcdef0' -var='ingress_rules=[
  {
    description      = "App from ALB SG"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    security_groups  = ["sg-0abcde1234567890f"]
    self             = false
  },
  {
    description      = "Allow intra-SG traffic"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    security_groups  = []
    self             = true
  }
]'

Saídas
- security_group_id: ID do SG.
- security_group_arn: ARN do SG.
- security_group_name: Nome do SG.
- security_group_vpc_id: VPC do SG.
- ingress_rule_ids: IDs das regras de entrada criadas.
- egress_rule_ids: IDs das regras de saída criadas.

Notas
- Para regras com múltiplos security_groups, é criado um recurso por destino/origem.
- Para regras com CIDR IPv4 e IPv6 no mesmo item, ambos são aplicados na mesma regra.
- Evite misturar muitas origens/destinos diferentes em um único item quando precisar de controle individual de lifecycle por regra; crie itens separados conforme necessário.
