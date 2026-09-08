Nome
- Security Group AWS via Terraform

Descricao
- Blueprint Terraform para criar um Security Group na AWS com regras de entrada e saida declarativas e seguras por padrao (sem regras por default).

Recursos criados
- aws_security_group
- aws_security_group_rule (ingress)
- aws_security_group_rule (egress)

Requisitos
- Terraform >= 1.0.0
- Provider AWS >= 4.0
- Uma VPC existente (forneca o vpc_id)
- Credenciais AWS configuradas (variaveis de ambiente, perfil, etc.) para aplicar

Entradas
- region (string): Regiao AWS. Default: us-east-1.
- vpc_id (string): ID da VPC onde o SG sera criado. Obrigatorio.
- sg_name (string): Nome do Security Group. Default: secure-sg.
- sg_description (string): Descricao do SG. Default: Security Group managed by Terraform.
- revoke_rules_on_delete (bool): Revoga regras antes de deletar o SG. Default: true.
- tags (map(string)): Tags adicionais. Default: {}.
- ingress_rules (list(object)): Lista de regras de entrada. Cada regra exige exatamente UMA origem entre cidr_blocks, ipv6_cidr_blocks, prefix_list_ids ou source_security_group_id. Se protocol = "-1", defina from_port = 0 e to_port = 0.
  Campos:
  - description (string)
  - protocol (string, ex: tcp, udp, icmp, -1)
  - from_port (number)
  - to_port (number)
  - cidr_blocks (list(string))
  - ipv6_cidr_blocks (list(string))
  - prefix_list_ids (list(string))
  - source_security_group_id (string)
- egress_rules (list(object)): Lista de regras de saida. Cada regra exige exatamente UM destino entre cidr_blocks, ipv6_cidr_blocks, prefix_list_ids ou destination_security_group_id. Se protocol = "-1", defina from_port = 0 e to_port = 0.
  Campos:
  - description (string)
  - protocol (string, ex: tcp, udp, icmp, -1)
  - from_port (number)
  - to_port (number)
  - cidr_blocks (list(string))
  - ipv6_cidr_blocks (list(string))
  - prefix_list_ids (list(string))
  - destination_security_group_id (string)

Saidas
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- ingress_rule_ids
- egress_rule_ids
- ingress_rules_count
- egress_rules_count
- tags

Padroes seguros
- Nenhuma regra de ingress ou egress e criada por padrao. Defina explicitamente as regras necessarias.
- Atributo revoke_rules_on_delete habilitado por padrao para reduzir residuos de regras.

Exemplo de uso
module "sg" {
  source = "./."

  region  = "us-east-1"
  vpc_id  = "vpc-0123456789abcdef0"
  sg_name = "app-sg"

  tags = {
    Environment = "dev"
    Project     = "example"
  }

  ingress_rules = [
    {
      description              = "Allow HTTPS from anywhere (IPv4)"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      cidr_blocks              = ["0.0.0.0/0"]
      ipv6_cidr_blocks         = []
      prefix_list_ids          = []
      source_security_group_id = ""
    },
    {
      description              = "Allow SSH from admin subnet"
      protocol                 = "tcp"
      from_port                = 22
      to_port                  = 22
      cidr_blocks              = ["10.0.0.0/24"]
      ipv6_cidr_blocks         = []
      prefix_list_ids          = []
      source_security_group_id = ""
    }
  ]

  egress_rules = [
    {
      description                    = "Allow HTTPS outbound (IPv4)"
      protocol                       = "tcp"
      from_port                      = 443
      to_port                        = 443
      cidr_blocks                    = ["0.0.0.0/0"]
      ipv6_cidr_blocks               = []
      prefix_list_ids                = []
      destination_security_group_id  = ""
    }
  ]
}

Operacao
- terraform init -backend=false
- terraform validate
- terraform plan -var="vpc_id=vpc-0123456789abcdef0"
- terraform apply -var="vpc_id=vpc-0123456789abcdef0"

Observacoes
- Para permitir trafego entre dois SGs, use source_security_group_id (ingress) ou destination_security_group_id (egress) apontando para o ID do SG de origem/destino.
- Para regras que abrangem todos os protocolos, use protocol = "-1" e ports 0/0 conforme validacao.
- Evite 0.0.0.0/0 e ::/0 em ingress, a menos que absolutamente necessario.
