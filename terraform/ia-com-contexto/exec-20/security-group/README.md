Visão geral do recurso
Este template provisiona um Security Group AWS seguindo o padrão corporativo:
- Nome no formato <environment>-<system>-sg-<security_group_name>;
- Tags obrigatórias aplicadas a todos os recursos;
- Regras de segurança:
  - Proibido 0.0.0.0/0 (e ::/0) em qualquer porta além de 443/tcp nas regras de entrada;
  - Descrição obrigatória em todas as regras de entrada e saída;
  - Egress explícito: nenhuma saída é liberada por padrão, devendo ser configurada via variável.

Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome                      | Tipo                                   | Obrigatória | Descrição |
|---------------------------|----------------------------------------|-------------|-----------|
| environment               | string                                  | Sim         | Ambiente alvo. Um de: dev, hml, prd. |
| system                    | string                                  | Sim         | Identificador do sistema/aplicação (minúsculas, números e hífens). |
| region                    | string                                  | Sim         | Região AWS para o provider. |
| additional_tags           | map(string)                             | Não         | Tags adicionais a serem aplicadas ao recurso. Não sobrescreve tags obrigatórias. |
| vpc_id                    | string                                  | Sim         | ID da VPC onde o Security Group será criado. |
| security_group_name       | string                                  | Sim         | Finalidade/nome do Security Group. Comporá o nome final conforme padrão. |
| security_group_description| string                                  | Não         | Descrição do Security Group. Padrão: "Security Group gerenciado por Terraform". |
| ingress_rules             | list(object)                            | Não         | Regras de entrada. Campos: description (obrigatório), protocol, from_port, to_port, cidr_blocks (opcional), ipv6_cidr_blocks (opcional). Restrições: descrição obrigatória; ao menos um destino; 0.0.0.0/0 ou ::/0 somente para 443/tcp; portas válidas (0-65535) ou protocolo -1 com from/to=0. |
| egress_rules              | list(object)                            | Não         | Regras de saída. Campos: description (obrigatório), protocol, from_port, to_port, cidr_blocks (opcional), ipv6_cidr_blocks (opcional). Restrições: descrição obrigatória; ao menos um destino; portas válidas (0-65535) ou protocolo -1 com from/to=0. Por padrão, nenhuma saída é liberada. |

Tabela de outputs (nome, descrição)
| Nome                 | Descrição |
|----------------------|-----------|
| security_group_name  | Nome do Security Group seguindo o padrão corporativo. |
| security_group_arn   | ARN do Security Group. |
| security_group_id    | ID do Security Group. |

Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "."

  region      = "us-east-1"
  environment = "dev"
  system      = "tcc"
  vpc_id      = "vpc-0123456789abcdef0"

  security_group_name        = "web"
  security_group_description = "Security Group para a camada web"

  additional_tags = {
    Squad = "platform"
  }

  ingress_rules = [
    {
      description      = "HTTPS público"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "SSH restrito do bastion"
      protocol         = "tcp"
      from_port        = 22
      to_port          = 22
      cidr_blocks      = ["10.0.0.0/24"]
      ipv6_cidr_blocks = []
    }
  ]

  egress_rules = [
    {
      description      = "Saída HTTPS para internet"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}
