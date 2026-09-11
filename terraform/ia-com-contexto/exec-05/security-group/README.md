Visão geral do recurso
Este template cria um Security Group (SG) na AWS obedecendo ao padrão organizacional:
- Nomenclatura: <environment>-<system>-sg-<security_group_name>
- Tags obrigatórias aplicadas
- Regras de segurança específicas:
  - Proibido 0.0.0.0/0 (e ::/0) para qualquer porta diferente da 443/tcp
  - Descrição obrigatória em toda regra de entrada e saída
  - Egress declarado de forma explícita e não irrestrito por padrão (padrão libera apenas 443/tcp para Internet)

Tabela de variáveis
| Nome                   | Tipo                                                                                                  | Obrigatória | Descrição |
|------------------------|-------------------------------------------------------------------------------------------------------|-------------|-----------|
| region                 | string                                                                                                | Sim         | Região AWS onde o SG será criado (ex.: us-east-1). |
| environment            | string                                                                                                | Sim         | Ambiente: dev, hml ou prd. |
| system                 | string                                                                                                | Sim         | Nome do sistema/aplicação (minúsculas, números e hífens). |
| security_group_name    | string                                                                                                | Sim         | Finalidade/nome específico do SG. Usado no padrão de nomenclatura. |
| security_group_description | string                                                                                            | Não         | Descrição do SG. Padrão: "Security Group gerenciado por Terraform." |
| vpc_id                 | string                                                                                                | Sim         | ID da VPC onde o SG será criado (ex.: vpc-xxxxxxxx). |
| ingress_rules          | list(object({ description=string, protocol=string, from_port=number, to_port=number, cidr_blocks=list(string) opcional, ipv6_cidr_blocks=list(string) opcional, security_groups=list(string) opcional, self=bool opcional })) | Não         | Lista de regras de entrada. Descrição obrigatória em cada regra. 0.0.0.0/0 (ou ::/0) apenas para TCP/443 com from_port=to_port=443. Padrão: [] |
| egress_rules           | list(object({ description=string, protocol=string, from_port=number, to_port=number, cidr_blocks=list(string) opcional, ipv6_cidr_blocks=list(string) opcional, security_groups=list(string) opcional, self=bool opcional })) | Não         | Lista de regras de saída. Padrão seguro: libera apenas HTTPS (443/tcp) para Internet (IPv4 e IPv6). Mesmas restrições de validação do ingress. |
| additional_tags        | map(string)                                                                                           | Não         | Tags adicionais. As tags obrigatórias são sempre aplicadas e não devem ser removidas. |

Tabela de outputs
| Nome                  | Descrição |
|-----------------------|-----------|
| security_group_name   | Nome completo do Security Group criado. |
| security_group_arn    | ARN do Security Group criado. |
| security_group_id     | ID do Security Group criado. |

Exemplo de uso
module "sg_web" {
  source = "./"

  region               = "us-east-1"
  environment          = "dev"
  system               = "tcc"
  security_group_name  = "web"
  security_group_description = "SG para workload web"
  vpc_id               = "vpc-0123456789abcdef0"

  # Regras de entrada: HTTPS aberto e porta 8080 apenas para bloco interno
  ingress_rules = [
    {
      description      = "Allow HTTPS from Internet"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow 8080 from internal CIDR"
      protocol         = "tcp"
      from_port        = 8080
      to_port          = 8080
      cidr_blocks      = ["10.0.0.0/8"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    }
  ]

  # Egress explícito (padrão já libera apenas 443/tcp para Internet)
  egress_rules = [
    {
      description      = "Allow HTTPS egress to Internet"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      self             = false
    }
  ]

  additional_tags = {
    Application = "sample-app"
    Squad       = "platform"
  }
}
