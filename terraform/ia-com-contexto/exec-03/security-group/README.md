Visão geral do recurso
Este template provisiona um Security Group na AWS seguindo os padrões organizacionais de nomenclatura, tags e controles de segurança. O nome do recurso é composto por <environment>-<system>-sg-<security_group_name>. As regras de entrada e saída são totalmente configuráveis por variáveis, a descrição é obrigatória em toda regra e é proibido utilizar 0.0.0.0/0 (e ::/0) em portas diferentes de 443/tcp. O egress é declarado explicitamente e não é liberado irrestritamente por padrão.

Tabela de variáveis
- environment (string) [obrigatória]: Ambiente do recurso. Valores possíveis: dev, hml, prd.
- system (string) [obrigatória]: Identificador do sistema/aplicação (minúsculas, números e hífens).
- region (string) [obrigatória]: Região AWS para o provisionamento (ex.: us-east-1).
- additional_tags (map(string)) [opcional]: Tags adicionais a aplicar no recurso. Em caso de chaves duplicadas, estas sobrescrevem as tags padrão.
- vpc_id (string) [obrigatória]: ID da VPC onde o Security Group será criado.
- security_group_name (string) [obrigatória]: Finalidade do Security Group, usada na composição do nome conforme padrão <env>-<system>-sg-<finalidade>.
- security_group_description (string) [opcional]: Descrição do Security Group.
- ingress_rules (list(object)) [opcional]: Lista de regras de entrada. Estrutura de cada item:
  - description (string) obrigatório;
  - from_port (number) obrigatório;
  - to_port (number) obrigatório;
  - protocol (string) obrigatório. Permitidos: tcp, udp, icmp, icmpv6, -1;
  - cidr_blocks (list(string)) pelo menos um bloco IPv4 ou IPv6 deve ser informado;
  - ipv6_cidr_blocks (list(string)) pelo menos um bloco IPv4 ou IPv6 deve ser informado.
  Restrições: 0.0.0.0/0 (e ::/0) só é permitido em 443/tcp.
- egress_rules (list(object)) [opcional]: Lista de regras de saída. Estrutura de cada item:
  - description (string) obrigatório;
  - from_port (number) obrigatório;
  - to_port (number) obrigatório;
  - protocol (string) obrigatório. Permitidos: tcp, udp, icmp, icmpv6, -1;
  - cidr_blocks (list(string)) pelo menos um bloco IPv4 ou IPv6 deve ser informado;
  - ipv6_cidr_blocks (list(string)) pelo menos um bloco IPv4 ou IPv6 deve ser informado.
  Restrições: 0.0.0.0/0 (e ::/0) só é permitido em 443/tcp.

Tabela de outputs
- security_group_name: Nome do Security Group conforme padrão organizacional.
- security_group_arn: ARN do Security Group criado.
- security_group_id: ID do Security Group criado.

Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "./."

  environment              = "dev"
  system                   = "tcc"
  region                   = "us-east-1"
  vpc_id                   = "vpc-0123456789abcdef0"
  security_group_name      = "web"
  security_group_description = "Security Group para workload web"
  additional_tags = {
    Application = "webapp"
    Squad       = "platform"
  }

  ingress_rules = [
    {
      description       = "Permitir HTTPS público"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = ["::/0"]
    },
    {
      description       = "Acesso SSH do bastion (exemplo de rede restrita)"
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      cidr_blocks       = ["10.0.10.0/24"]
      ipv6_cidr_blocks  = []
    }
  ]

  egress_rules = [
    {
      description       = "Saída HTTPS para serviços externos"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = ["::/0"]
    }
  ]
}

# Após aplicar, os principais atributos exportados:
# - module.sg_web.security_group_name
# - module.sg_web.security_group_arn
# - module.sg_web.security_group_id
