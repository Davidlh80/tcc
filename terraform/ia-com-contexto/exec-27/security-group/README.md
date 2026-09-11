1. Visão geral do recurso
Este template provisiona um Security Group na AWS em conformidade com as políticas internas de IaC:
- Nome seguindo o padrão <environment>-<system>-sg-<security_group_name>;
- Tags obrigatórias aplicadas a todos os recursos;
- Regras de segurança:
  - Proibido 0.0.0.0/0 para qualquer porta que não seja 443/tcp (aplica-se a ingress e egress);
  - Descrição obrigatória em todas as regras de entrada e saída;
  - Egress declarado de forma explícita e, por padrão, sem liberação irrestrita;
  - Regras de entrada e saída totalmente configuráveis por variáveis;
  - VPC configurável por variável.

2. Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment | string | sim | Ambiente do recurso: dev, hml ou prd.
- system | string | sim | Nome do sistema (minúsculas, números e hífens).
- region | string | sim | Região AWS (ex.: us-east-1).
- additional_tags | map(string) | não | Tags adicionais a serem aplicadas. Não sobrescreve as tags obrigatórias.
- security_group_name | string | sim | Finalidade do Security Group (compõe o nome).
- vpc_id | string | sim | ID da VPC onde o SG será criado.
- security_group_description | string | não | Descrição do Security Group (padrão: Security Group gerenciado por Terraform).
- ingress_rules | list(object) | não | Regras de entrada. Campos: description (string), protocol (string), from_port (number), to_port (number), cidr_blocks (list(string), opcional), ipv6_cidr_blocks (list(string), opcional). Descrição obrigatória; 0.0.0.0/0 somente tcp/443; from_port <= to_port.
- egress_rules | list(object) | não | Regras de saída. Mesmos campos e validações de ingress_rules. Por padrão, sem egress liberado.

3. Tabela de outputs (nome, descrição)
- security_group_name | Nome final do Security Group criado.
- security_group_arn | ARN do Security Group.
- security_group_id | ID do Security Group.

4. Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "."

  environment             = "dev"
  system                  = "tcc"
  region                  = "us-east-1"
  vpc_id                  = "vpc-0123456789abcdef0"
  security_group_name     = "web"
  security_group_description = "SG para workload web (80->ALB interno; 443 público)"

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
      ipv6_cidr_blocks = []
    },
    {
      description      = "Healthcheck interno"
      protocol         = "tcp"
      from_port        = 8080
      to_port          = 8080
      cidr_blocks      = ["10.0.0.0/8"]
      ipv6_cidr_blocks = []
    }
  ]

  egress_rules = [
    {
      description      = "Saída HTTP para repositórios internos"
      protocol         = "tcp"
      from_port        = 80
      to_port          = 80
      cidr_blocks      = ["10.0.0.0/8"]
      ipv6_cidr_blocks = []
    }
  ]
}
