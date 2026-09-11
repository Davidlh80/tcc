Visão geral do recurso
Este template provisiona um Security Group na AWS seguindo o padrão de nomenclatura <environment>-<system>-sg-<security_group_name>, com tags obrigatórias aplicadas e controles de segurança que:
- Proíbem 0.0.0.0/0 em qualquer porta além de 443/tcp nas regras de entrada (validação em variável).
- Exigem descrição em todas as regras de entrada e saída.
- Declararam egress de forma explícita. Quando não informado pelo usuário, aplica-se um egress restritivo padrão (self=true), evitando liberação irrestrita por padrão.
- Permitem configurar VPC, regras de entrada e saída via variáveis.

Tabela de variáveis
| Nome                     | Tipo                                                                                                      | Obrigatória | Descrição                                                                                                                     | Default                     |
|--------------------------|-----------------------------------------------------------------------------------------------------------|-------------|--------------------------------------------------------------------------------------------------------------------------------|-----------------------------|
| environment              | string                                                                                                   | Sim         | Ambiente alvo: dev, hml ou prd.                                                                                               | n/a                         |
| system                   | string                                                                                                   | Sim         | Nome do sistema (minúsculas, números e hifens).                                                                               | n/a                         |
| region                   | string                                                                                                   | Sim         | Região AWS (ex.: us-east-1).                                                                                                  | n/a                         |
| security_group_name      | string                                                                                                   | Sim         | Nome/finalidade do SG (usado em <environment>-<system>-sg-<security_group_name>).                                             | n/a                         |
| security_group_description | string                                                                                                 | Não         | Descrição do Security Group.                                                                                                  | "Managed by Terraform"      |
| vpc_id                   | string                                                                                                   | Sim         | ID da VPC alvo (ex.: vpc-12345678abcdef12).                                                                                   | n/a                         |
| ingress_rules            | list(object({ description=string, protocol=string, from_port=number, to_port=number, cidr_blocks=list(string), ipv6_cidr_blocks=list(string), security_groups=list(string), prefix_list_ids=list(string), self=bool })) | Não         | Regras de entrada. Cada regra deve ter description e pelo menos um destino (cidr/ipv6/SG/prefix/self). 0.0.0.0/0 só em 443/tcp. | []                          |
| egress_rules             | list(object({ description=string, protocol=string, from_port=number, to_port=number, cidr_blocks=list(string), ipv6_cidr_blocks=list(string), security_groups=list(string), prefix_list_ids=list(string), self=bool }))  | Não         | Regras de saída. Se vazio, aplica-se egress padrão restritivo (self=true) para evitar liberação irrestrita.                   | []                          |
| additional_tags          | map(string)                                                                                              | Não         | Tags adicionais a serem mescladas às obrigatórias.                                                                             | {}                          |

Tabela de outputs
| Nome                  | Descrição                       |
|-----------------------|---------------------------------|
| security_group_name   | Nome do Security Group criado.  |
| security_group_arn    | ARN do Security Group criado.   |
| security_group_id     | ID do Security Group criado.    |

Exemplo de uso
module "sg" {
  source = "./"

  region                = "us-east-1"
  environment           = "dev"
  system                = "tcc"
  security_group_name   = "web"
  security_group_description = "Security Group da aplicação web"
  vpc_id                = "vpc-12345678abcdef12"

  # Permite HTTPS público (conforme política: 0.0.0.0/0 apenas em 443/tcp)
  ingress_rules = [
    {
      description       = "Allow HTTPS from Internet"
      protocol          = "tcp"
      from_port         = 443
      to_port           = 443
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      security_groups   = []
      prefix_list_ids   = []
      self              = false
    },
    {
      description       = "Allow HTTP from ALB SG"
      protocol          = "tcp"
      from_port         = 80
      to_port           = 80
      cidr_blocks       = []
      ipv6_cidr_blocks  = []
      security_groups   = ["sg-abcdef01234567890"]
      prefix_list_ids   = []
      self              = false
    }
  ]

  # Sem egress explícito informado -> aplica egress padrão restritivo (self=true)
  egress_rules = []

  additional_tags = {
    Application = "webapp"
  }
}

Saída esperada
- security_group_name: dev-tcc-sg-web
- security_group_id: sg-XXXXXXXX
- security_group_arn: arn:aws:ec2:us-east-1:123456789012:security-group/sg-XXXXXXXX
