Visão geral do recurso
Este template provisiona um Security Group na AWS seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-sg-<security_group_name>
- Tags obrigatórias aplicadas a todos os recursos
- Regras de segurança:
  - Proibição de 0.0.0.0/0 em qualquer porta além de 443/tcp
  - Descrição obrigatória em toda regra de entrada e de saída
  - Egress declarado explicitamente (obrigatório ao menos uma regra), sem liberação irrestrita por padrão
- Variáveis expostas para configuração de VPC, regras de ingress/egress e metadados

Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment | string | sim | Ambiente do recurso. Valores: dev, hml, prd.
- system | string | sim | Nome do sistema/produto, em minúsculas com hífens (padrão corporativo).
- region | string | sim | Região AWS (ex.: us-east-1).
- additional_tags | map(string) | não | Tags adicionais aplicadas além das obrigatórias.
- vpc_id | string | sim | ID da VPC alvo (ex.: vpc-xxxxxxxx).
- security_group_name | string | sim | Finalidade/nome lógico do SG (usado na composição do nome).
- ingress_rules | list(object) | não | Regras de entrada. Default: []. Campos: description (string), from_port (number), to_port (number), protocol (string), cidr_blocks (list(string), opcional), ipv6_cidr_blocks (list(string), opcional), security_group_ids (list(string), opcional), self (bool, opcional). Restrições: descrição obrigatória; ao menos uma origem/destino por regra; se usar 0.0.0.0/0 deve ser exclusivamente tcp:443.
- egress_rules | list(object) | sim | Regras de saída. Campos: description (string), from_port (number), to_port (number), protocol (string), cidr_blocks (list(string), opcional), ipv6_cidr_blocks (list(string), opcional), security_group_ids (list(string), opcional), self (bool, opcional). Restrições: ao menos uma regra (egress explícito); descrição obrigatória; ao menos um destino por regra; se usar 0.0.0.0/0 deve ser exclusivamente tcp:443.

Tabela de outputs (nome, descrição)
- security_group_name | Nome final do Security Group criado.
- security_group_arn | ARN do Security Group.
- security_group_id | ID do Security Group.

Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "./"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"

  additional_tags = {
    Squad = "platform"
  }

  ingress_rules = [
    {
      description        = "Permite HTTPS público"
      from_port          = 443
      to_port            = 443
      protocol           = "tcp"
      cidr_blocks        = ["0.0.0.0/0"]
      ipv6_cidr_blocks   = []
      security_group_ids = []
      self               = false
    },
    {
      description        = "Permite HTTP interno do ALB"
      from_port          = 80
      to_port            = 80
      protocol           = "tcp"
      cidr_blocks        = ["10.0.0.0/16"]
      ipv6_cidr_blocks   = []
      security_group_ids = []
      self               = false
    }
  ]

  egress_rules = [
    {
      description        = "Saída HTTPS para dependências externas"
      from_port          = 443
      to_port            = 443
      protocol           = "tcp"
      cidr_blocks        = ["0.0.0.0/0"]
      ipv6_cidr_blocks   = []
      security_group_ids = []
      self               = false
    }
  ]
}
