Visão geral do recurso
Este template cria um Security Group na AWS seguindo o padrão organizacional:
- Nome no formato <ambiente>-<sistema>-sg-<finalidade>.
- Aplicação de tags obrigatórias.
- Regras de segurança:
  - Proíbe 0.0.0.0/0 e ::/0 em qualquer porta além de 443/tcp.
  - Exige descrição em todas as regras de entrada e saída.
  - Egress declarado de forma explícita: por padrão, apenas HTTPS (443/tcp) para Internet.
  - Configuração de VPC e regras via variáveis.

Tabela de variáveis
- environment (string) [obrigatória]: Ambiente do recurso. Valores permitidos: dev, hml, prd.
- system (string) [obrigatória]: Nome do sistema/aplicação (minúsculas, números e hifens).
- region (string) [obrigatória]: Região AWS (ex.: us-east-1).
- additional_tags (map(string)) [opcional]: Tags adicionais a serem mescladas às tags obrigatórias.
- vpc_id (string) [obrigatória]: ID da VPC onde o Security Group será criado.
- security_group_name (string) [obrigatória]: Finalidade do Security Group (compõe o sufixo do nome).
- security_group_description (string) [opcional]: Descrição do Security Group. Padrão: "Security Group gerenciado por Terraform".
- ingress_rules (list(object)) [opcional]: Regras de entrada. Cada objeto deve conter:
  - description (string)
  - protocol (string, ex.: tcp, udp, icmp, -1)
  - from_port (number)
  - to_port (number)
  - cidr_blocks (list(string))
  - ipv6_cidr_blocks (list(string))
  Observações: descrição é obrigatória; ao menos um CIDR (IPv4/IPv6) por regra; 0.0.0.0/0 e ::/0 só são permitidos em 443/tcp.
- egress_rules (list(object)) [opcional]: Regras de saída. Mesmo formato de ingress_rules. Padrão seguro e explícito: apenas 443/tcp para 0.0.0.0/0.

Tabela de outputs
- security_group_name: Nome do Security Group criado.
- security_group_arn: ARN do Security Group criado.
- security_group_id: ID do Security Group criado.

Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "./."

  region               = "us-east-1"
  environment          = "hml"
  system               = "tcc"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"
  security_group_description = "Security Group para aplicação web (camada HTTP/HTTPS)"

  # Regras de entrada: HTTP interno (exemplo) e HTTPS público
  ingress_rules = [
    {
      description      = "Allow HTTPS from Internet"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    },
    {
      description      = "Allow HTTP from private CIDR"
      protocol         = "tcp"
      from_port        = 80
      to_port          = 80
      cidr_blocks      = ["10.0.0.0/16"]
      ipv6_cidr_blocks = []
    }
  ]

  # Egress explícito (mantendo padrão seguro: somente 443/tcp para Internet)
  egress_rules = [
    {
      description      = "HTTPS egress to Internet"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }
  ]

  additional_tags = {
    Application = "my-app"
    Squad       = "platform"
  }
}
