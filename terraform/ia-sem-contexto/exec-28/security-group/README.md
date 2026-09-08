Blueprint Terraform — AWS Security Group

Visao geral
Este template cria um Security Group (SG) na AWS em uma VPC informada via variavel. Por padrao, nenhuma porta de entrada (ingress) e liberada e toda a saida (egress) IPv4 e permitida. As regras podem ser configuradas via variaveis.

Requisitos
- Terraform >= 1.3
- Provider AWS >= 5.0
- Uma VPC existente (fornecer vpc_id)

Entradas (principais variaveis)
- region: Regiao AWS (default: us-east-1)
- vpc_id: ID da VPC onde o SG sera criado (obrigatorio)
- name: Nome do SG (default: sg-managed)
- description: Descricao do SG
- ingress_rules: Lista de regras de entrada (default: [])
- egress_rules: Lista de regras de saida (default: libera tudo IPv4)
- tags: Mapa de tags adicionais

Formato das regras (ingress_rules e egress_rules)
Cada item da lista deve ser um objeto com:
- from_port (number)
- to_port (number)
- protocol (string; ex.: tcp, udp, icmp, -1)
- cidr_blocks (list(string), opcional)
- ipv6_cidr_blocks (list(string), opcional)
- security_groups (list(string), opcional)
- self (bool, opcional)
- description (string, opcional)

Observacoes
- Se protocol = -1 (todos), from_port e to_port devem ser 0.
- Pelo menos uma origem/destino deve ser definida em cada regra: cidr_blocks, ipv6_cidr_blocks, security_groups ou self = true.
- O template nao configura backend remoto.

Exemplo de uso basico
- Defina o ID da VPC:
  vpc_id = "vpc-0123456789abcdef0"

- Opcional: liberar SSH de um CIDR especifico e HTTP do proprio SG:
  ingress_rules = [
    {
      description      = "SSH from office"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["203.0.113.0/24"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    },
    {
      description      = "HTTP from self"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      self             = true
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = []
    }
  ]

Comandos uteis
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Saidas
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- security_group_owner_id
- ingress_rules_count
- egress_rules_count
