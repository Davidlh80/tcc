1. Visão geral do recurso
Este template provisiona um Security Group na AWS seguindo a política interna de IaC:
- Nome no padrão <ambiente>-<sistema>-<recurso>-<finalidade>, onde recurso = sg.
- VPC configurável por variável.
- Regras de entrada e saída definidas por variáveis, exigindo descrição em todas.
- Proibição de 0.0.0.0/0 e ::/0 para qualquer porta diferente de 443/tcp (validado via variável).
- Egress explicitamente declarado via recursos dedicados, sem liberação irrestrita por padrão.
- Tags obrigatórias aplicadas automaticamente.

2. Tabela de variáveis
| Nome                      | Tipo                                                                                  | Obrigatória | Descrição |
|---------------------------|---------------------------------------------------------------------------------------|-------------|-----------|
| region                    | string                                                                               | Sim         | Região AWS onde os recursos serão criados (ex.: us-east-1). |
| environment               | string                                                                               | Sim         | Ambiente do recurso. Valores permitidos: dev, hml, prd. |
| system                    | string                                                                               | Sim         | Nome do sistema (minúsculo, números e hífens). |
| additional_tags           | map(string)                                                                          | Não         | Tags adicionais a serem aplicadas aos recursos. |
| vpc_id                    | string                                                                               | Sim         | ID da VPC onde o Security Group será criado. |
| security_group_name       | string                                                                               | Sim         | Finalidade do Security Group (parte final do nome). Ex.: web, db, bastion. |
| security_group_description| string                                                                               | Não         | Descrição do Security Group. Padrão: "Security group gerenciado por Terraform". |
| ingress_rules             | list(object({description=string, from_port=number, to_port=number, protocol=string, cidr_blocks=list(string), ipv6_cidr_blocks=list(string)})) | Não | Lista de regras de entrada. Cada regra deve ter descrição e ao menos um CIDR (IPv4 ou IPv6). 0.0.0.0/0 ou ::/0 apenas para TCP/443. |
| egress_rules              | list(object({description=string, from_port=number, to_port=number, protocol=string, cidr_blocks=list(string), ipv6_cidr_blocks=list(string)})) | Não | Lista de regras de saída. Cada regra deve ter descrição e ao menos um CIDR (IPv4 ou IPv6). 0.0.0.0/0 ou ::/0 apenas para TCP/443. Padrão sem regras. |

3. Tabela de outputs
| Nome                 | Descrição |
|----------------------|-----------|
| security_group_name  | Nome completo do Security Group criado. |
| security_group_arn   | ARN do Security Group criado. |
| security_group_id    | ID do Security Group criado. |

4. Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "."

  region               = "us-east-1"
  environment          = "dev"
  system               = "tcc"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"
  security_group_description = "SG para workload web (dev)"

  # Ingress: HTTPS aberto ao mundo (permitido pela política) e SSH restrito
  ingress_rules = [
    {
      description       = "HTTPS público"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = ["::/0"]
    },
    {
      description       = "SSH restrito"
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      cidr_blocks       = ["203.0.113.10/32"]
      ipv6_cidr_blocks  = []
    }
  ]

  # Egress: permitir apenas HTTPS para a Internet
  egress_rules = [
    {
      description       = "Egress HTTPS"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = ["::/0"]
    }
  ]

  additional_tags = {
    Application = "web-app"
    Squad       = "platform"
  }
}
