1. Visão geral do recurso
Este template provisiona um Security Group na AWS seguindo o padrão organizacional:
- Nome no formato: <environment>-<system>-sg-<security_group_name>.
- Tags obrigatórias aplicadas a todos os recursos.
- Regras de segurança:
  - Proibição de 0.0.0.0/0 em qualquer porta além de 443/tcp (válido para ingress e egress).
  - Toda regra de entrada e de saída exige descrição.
  - Egress deve ser declarado explicitamente (sem liberação irrestrita por padrão), portanto egress_rules é obrigatório.

2. Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome                      | Tipo                                                            | Obrigatória | Descrição                                                                                          |
|---------------------------|-----------------------------------------------------------------|------------|----------------------------------------------------------------------------------------------------|
| environment               | string                                                          | Sim        | Ambiente de implantação (dev, hml, prd).                                                           |
| system                    | string                                                          | Sim        | Identificador do sistema/produto (minúsculas, números e hífens).                                   |
| region                    | string                                                          | Sim        | Região AWS (ex.: us-east-1).                                                                       |
| additional_tags           | map(string)                                                     | Não        | Tags adicionais mescladas às tags obrigatórias.                                                    |
| security_group_name       | string                                                          | Sim        | Finalidade do Security Group (sufixo do nome).                                                     |
| security_group_description| string                                                          | Não        | Descrição do Security Group.                                                                       |
| vpc_id                    | string                                                          | Sim        | ID da VPC alvo (ex.: vpc-xxxxxxxx).                                                                |
| ingress_rules             | list(object({description=string, protocol=string, from_port=number, to_port=number, cidr_blocks=list(string)})) | Não        | Regras de entrada. Exige descrição; 0.0.0.0/0 permitido apenas para tcp/443.                       |
| egress_rules              | list(object({description=string, protocol=string, from_port=number, to_port=number, cidr_blocks=list(string)}))  | Sim        | Regras de saída. Obrigatório; exige descrição; 0.0.0.0/0 permitido apenas para tcp/443.            |

3. Tabela de outputs (nome, descrição)
| Nome                  | Descrição                                   |
|-----------------------|----------------------------------------------|
| security_group_name   | Nome do Security Group criado.              |
| security_group_arn    | ARN do Security Group.                      |
| security_group_id     | ID do Security Group.                       |

4. Exemplo de uso do módulo/recurso
module "sg_web" {
  source  = "./"
  region  = "us-east-1"

  environment          = "hml"
  system               = "tcc"
  security_group_name  = "web"
  security_group_description = "Security Group para camadas web"
  vpc_id               = "vpc-0123456789abcdef0"

  # Ingress: HTTPS público e SSH restrito
  ingress_rules = [
    {
      description = "HTTPS público"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "SSH do bastion"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["10.0.1.0/24"]
    }
  ]

  # Egress explícito (sem liberação irrestrita):
  egress_rules = [
    {
      description = "Saída HTTPS para a internet"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "DNS UDP para resolvers internos"
      protocol    = "udp"
      from_port   = 53
      to_port     = 53
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  additional_tags = {
    Application = "sample-app"
    Team        = "platform"
  }
}
