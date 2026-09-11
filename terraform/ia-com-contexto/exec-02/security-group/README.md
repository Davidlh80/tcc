Visão geral do recurso
Este template cria um Security Group na AWS seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-sg-<security_group_name>
- Tags obrigatórias aplicadas em todos os recursos com suporte
- Regras de segurança:
  - Proibido 0.0.0.0/0 e ::/0 para qualquer porta diferente de 443/tcp (aplicado a ingress e egress)
  - Descrição obrigatória em toda regra de entrada e saída
  - Egress declarado explicitamente; por padrão, nenhuma saída é liberada (egress_rules = [])

Tabela de variáveis
| Nome                       | Tipo                                                                       | Obrigatória | Descrição |
|----------------------------|----------------------------------------------------------------------------|-------------|-----------|
| region                     | string                                                                     | Sim         | Região AWS onde os recursos serão criados (ex.: us-east-1). |
| environment                | string                                                                     | Sim         | Ambiente do recurso. Valores permitidos: dev, hml, prd. |
| system                     | string                                                                     | Sim         | Nome do sistema/aplicação (minúsculas, números e hífens). |
| additional_tags            | map(string)                                                                | Não         | Tags adicionais a serem mescladas. Não substituem as tags obrigatórias. |
| security_group_name        | string                                                                     | Sim         | Finalidade do Security Group (usado na nomenclatura). |
| vpc_id                     | string                                                                     | Sim         | ID da VPC onde o Security Group será criado. |
| security_group_description | string                                                                     | Não         | Descrição do Security Group. Padrão: "Security Group gerenciado pelo Terraform". |
| ingress_rules              | list(object)                                                               | Não         | Regras de entrada. Exigem descrição. Público (0.0.0.0/0 ou ::/0) somente para 443/tcp. |
| egress_rules               | list(object)                                                               | Não         | Regras de saída. Exigem descrição. Público (0.0.0.0/0 ou ::/0) somente para 443/tcp. Se vazio, nenhuma saída é permitida. |

Estrutura dos objetos de regra (ingress_rules/egress_rules):
- description (string, obrigatório)
- protocol (string, obrigatório, ex.: "tcp", "udp", "-1")
- from_port (number, obrigatório)
- to_port (number, obrigatório)
- cidr_blocks (list(string), opcional)
- ipv6_cidr_blocks (list(string), opcional)
- security_groups (list(string), opcional)
- self (bool, opcional)

Tabela de outputs
| Nome                   | Descrição |
|------------------------|-----------|
| security_group_name    | Nome do Security Group criado. |
| security_group_arn     | ARN do Security Group criado. |
| security_group_id      | ID do Security Group criado. |

Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "./"

  region              = "us-east-1"
  environment         = "dev"
  system              = "tcc"
  security_group_name = "web"
  vpc_id              = "vpc-0123456789abcdef0"

  additional_tags = {
    Application = "my-app"
  }

  security_group_description = "SG de front-end web com acesso HTTPS público controlado"

  ingress_rules = [
    {
      description      = "Permitir HTTPS público"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  # Sem regras de egress por padrão (bloqueia toda saída).
  egress_rules = []
}
