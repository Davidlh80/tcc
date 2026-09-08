Blueprint Terraform — AWS Security Group

Descricao
- Provisiona um Security Group (SG) em uma VPC especificada.
- Seguro por padrao: nenhum ingress e nenhum egress sao criados a menos que explicitamente definidos.
- Totalmente configuravel via variaveis.

Requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS disponiveis no ambiente (ex.: variaveis de ambiente, arquivo de credenciais ou perfil)

Arquivos
- versions.tf: Versoes requeridas do Terraform e provider.
- main.tf: Provider AWS e recurso aws_security_group com regras dinamicas.
- variables.tf: Variaveis com validacao.
- outputs.tf: Saidas principais.
- README.md: Este guia.

Variaveis principais
- aws_region: Regiao AWS (padrao: us-east-1)
- vpc_id: ID da VPC alvo (obrigatorio)
- sg_name: Nome do SG (padrao: secure-sg)
- description: Descricao do SG
- tags: Tags adicionais (mapa de strings)
- ingress_rules: Lista de regras de entrada
- egress_rules: Lista de regras de saida

Modelo de regra (ingress_rules e egress_rules)
- Cada item deve conter:
  - from_port (number)
  - to_port (number)
  - protocol (string: tcp, udp, icmp, icmpv6, -1, ou numero)
  - Pelo menos um destino/origem: cidr_blocks, ipv6_cidr_blocks ou security_group_ids
  - description (opcional)

Exemplo de uso (basico)
- Definir apenas a VPC e manter SG sem trafego permitido:
  - vpc_id = "vpc-0123456789abcdef0"

Exemplo de uso (com regras)
  vpc_id      = "vpc-0123456789abcdef0"
  sg_name     = "app-sg"
  aws_region  = "us-east-1"

  ingress_rules = [
    {
      description        = "HTTP da Internet"
      from_port          = 80
      to_port            = 80
      protocol           = "tcp"
      cidr_blocks        = ["0.0.0.0/0"]
      ipv6_cidr_blocks   = []
      security_group_ids = []
    },
    {
      description        = "SSH somente da rede corporativa"
      from_port          = 22
      to_port            = 22
      protocol           = "tcp"
      cidr_blocks        = ["203.0.113.0/24"]
      ipv6_cidr_blocks   = []
      security_group_ids = []
    }
  ]

  egress_rules = [
    {
      description        = "Saida para qualquer destino (nao recomendado em prod)"
      from_port          = 0
      to_port            = 0
      protocol           = "-1"
      cidr_blocks        = ["0.0.0.0/0"]
      ipv6_cidr_blocks   = ["::/0"]
      security_group_ids = []
    }
  ]

Comandos tipicos
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Boas praticas
- Restringir cidr_blocks e ipv6_cidr_blocks ao minimo necessario.
- Preferir security_group_ids para trafego interno entre recursos na mesma VPC.
- Evitar liberar portas amplamente; usar faixas de IP controladas.
