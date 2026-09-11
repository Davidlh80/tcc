1. Visão geral do recurso
Este template provisiona um Security Group seguindo o padrão organizacional:
- Nome no formato <ambiente>-<sistema>-sg-<finalidade>;
- Tags corporativas obrigatórias aplicadas automaticamente;
- Políticas de segurança:
  - Proíbe 0.0.0.0/0 (e ::/0) para qualquer porta diferente de 443/tcp;
  - Exige descrição em toda regra de entrada e saída;
  - Egress declarado de forma explícita (obrigatório pelo usuário), evitando liberação irrestrita por padrão;
  - Regras de ingress e egress configuráveis por variáveis;
  - VPC configurável por variável.

2. Tabela de variáveis
| Nome                      | Tipo                                                                                 | Obrigatória | Descrição |
|---------------------------|--------------------------------------------------------------------------------------|-------------|-----------|
| environment               | string                                                                              | Sim         | Ambiente da implantação. Valores permitidos: dev, hml, prd. |
| system                    | string                                                                              | Sim         | Identificador do sistema/aplicação (ex.: tcc). Somente minúsculas, números e hífens. |
| region                    | string                                                                              | Sim         | Região AWS alvo. |
| additional_tags           | map(string)                                                                         | Não         | Tags adicionais a serem mescladas às tags obrigatórias. |
| vpc_id                    | string                                                                              | Sim         | ID da VPC onde o Security Group será criado. |
| security_group_name       | string                                                                              | Sim         | Finalidade do SG (segmento final do padrão de nome). |
| security_group_description| string                                                                              | Não         | Descrição do Security Group. Padrão: "Managed by Terraform". |
| ingress_rules             | list(object({ description=string, protocol=string, from_port=number, to_port=number, cidr_blocks=list(string) opcional, ipv6_cidr_blocks=list(string) opcional, source_security_group_ids=list(string) opcional })) | Não         | Regras de entrada. Exige descrição. 0.0.0.0/0 (e ::/0) apenas para tcp/443 exatamente. |
| egress_rules              | list(object({ description=string, protocol=string, from_port=number, to_port=number, cidr_blocks=list(string) opcional, ipv6_cidr_blocks=list(string) opcional, source_security_group_ids=list(string) opcional })) | Sim         | Regras de saída explícitas. Exige descrição. 0.0.0.0/0 (e ::/0) apenas para tcp/443 exatamente. Deve conter ao menos uma regra. |

3. Tabela de outputs
| Nome                  | Descrição |
|-----------------------|-----------|
| security_group_name   | Nome do Security Group criado. |
| security_group_arn    | ARN do Security Group criado. |
| security_group_id     | ID do Security Group criado. |

4. Exemplo de uso do módulo/recurso
module "sg_web" {
  source  = "./este-modulo"
  region  = "us-east-1"

  environment          = "hml"
  system               = "tcc"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"
  security_group_description = "SG para front-end web"

  # Regras de entrada (exemplos)
  ingress_rules = [
    {
      description  = "HTTPS publico"
      protocol     = "tcp"
      from_port    = 443
      to_port      = 443
      cidr_blocks  = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      source_security_group_ids = []
    },
    {
      description  = "SSH jump-host (exemplo)"
      protocol     = "tcp"
      from_port    = 22
      to_port      = 22
      cidr_blocks  = ["10.0.0.0/24"]  # rede privada da org
      ipv6_cidr_blocks = []
      source_security_group_ids = []
    }
  ]

  # Regras de saída (explícitas)
  egress_rules = [
    {
      description  = "Saida HTTPS para Internet"
      protocol     = "tcp"
      from_port    = 443
      to_port      = 443
      cidr_blocks  = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      source_security_group_ids = []
    },
    {
      description  = "DNS UDP para resolvedor interno"
      protocol     = "udp"
      from_port    = 53
      to_port      = 53
      cidr_blocks  = ["10.0.0.53/32"]
      ipv6_cidr_blocks = []
      source_security_group_ids = []
    }
  ]

  additional_tags = {
    Service = "frontend"
  }
}
