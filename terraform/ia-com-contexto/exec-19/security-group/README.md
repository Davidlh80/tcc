Visão geral do recurso
Este template provisiona um Security Group na AWS seguindo o padrão organizacional:
- Nome no formato <ambiente>-<sistema>-sg-<finalidade>;
- Tags obrigatórias aplicadas a todos os recursos;
- Regras de entrada e saída configuráveis por variáveis;
- Proibição de 0.0.0.0/0 em qualquer porta além de 443/tcp (aplicado a ingress e egress);
- Descrição obrigatória em todas as regras de entrada e saída;
- Egress declarado explicitamente, com padrão seguro (apenas tcp/443).

Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome                      | Tipo                                                                 | Obrigatória | Descrição                                                                                         |
|--------------------------|----------------------------------------------------------------------|------------|---------------------------------------------------------------------------------------------------|
| region                   | string                                                               | Sim        | Região AWS para o provisionamento.                                                                |
| environment              | string                                                               | Sim        | Ambiente do recurso (dev, hml, prd).                                                              |
| system                   | string                                                               | Sim        | Nome do sistema/aplicação (kebab-case).                                                           |
| additional_tags          | map(string)                                                          | Não        | Tags adicionais a serem aplicadas. As tags obrigatórias sempre prevalecem.                        |
| vpc_id                   | string                                                               | Sim        | ID da VPC onde o Security Group será criado.                                                      |
| security_group_name      | string                                                               | Sim        | Finalidade do Security Group (compõe o nome final).                                               |
| security_group_description | string                                                             | Não        | Descrição do Security Group.                                                                      |
| ingress_rules            | list(object)                                                         | Não        | Regras de entrada. Descrição obrigatória. 0.0.0.0/0 permitido apenas para tcp/443.                |
| egress_rules             | list(object)                                                         | Não        | Regras de saída explícitas. Padrão seguro libera apenas tcp/443. 0.0.0.0/0 apenas para tcp/443.   |

Estrutura das regras (ingress_rules e egress_rules):
- Cada item é um objeto com os campos:
  - description (string, obrigatório)
  - protocol (string, obrigatório. Ex.: "tcp", "udp", "-1")
  - from_port (number, obrigatório)
  - to_port (number, obrigatório)
  - cidr_blocks (list(string), opcional, padrão [])
  - ipv6_cidr_blocks (list(string), opcional, padrão [])
  - prefix_list_ids (list(string), opcional, padrão [])
  - security_groups (list(string), opcional, padrão [])
  - self (bool, opcional, padrão false)
- Política: 0.0.0.0/0 só é permitido com protocol = "tcp", from_port = 443 e to_port = 443.
- Todas as regras devem ter description preenchida.

Tabela de outputs (nome, descrição)
| Nome                 | Descrição                          |
|---------------------|------------------------------------|
| security_group_name | Nome do Security Group criado.     |
| security_group_arn  | ARN do Security Group criado.      |
| security_group_id   | ID do Security Group criado.       |

Exemplo de uso do módulo/recurso
  module "sg_web" {
    source = "./"

    region      = "us-east-1"
    environment = "dev"
    system      = "tcc"
    vpc_id      = "vpc-0123456789abcdef0"

    security_group_name        = "web"
    security_group_description = "Security Group para workloads web"

    additional_tags = {
      Team = "platform"
    }

    ingress_rules = [
      {
        description      = "Allow HTTPS from internet"
        protocol         = "tcp"
        from_port        = 443
        to_port          = 443
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
      },
      {
        description      = "Allow app from private SG"
        protocol         = "tcp"
        from_port        = 8443
        to_port          = 8443
        cidr_blocks      = []
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = ["sg-0a1b2c3d4e5f6a7b8"]
        self             = false
      }
    ]

    # Padrão já liberaliza apenas HTTPS egresso. Para customizar:
    egress_rules = [
      {
        description      = "Egress HTTPS only"
        protocol         = "tcp"
        from_port        = 443
        to_port          = 443
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
      }
    ]
  }

Notas
- O nome final do Security Group seguirá o padrão organizacional: <environment>-<system>-sg-<security_group_name>, por exemplo: dev-tcc-sg-web.
- As tags obrigatórias são aplicadas automaticamente e prevalecem sobre chaves duplicadas informadas em additional_tags.
- Compatível com terraform fmt, terraform init -backend=false e terraform validate.
