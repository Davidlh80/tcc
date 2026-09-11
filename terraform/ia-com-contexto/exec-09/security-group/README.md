1. Visão geral do recurso
Este template provisiona um Security Group na AWS em conformidade com as diretrizes organizacionais:
- Nomeação no padrão <ambiente>-<sistema>-<recurso>-<finalidade>, por exemplo: dev-tcc-sg-web.
- Tags obrigatórias aplicadas: Project, Environment, ManagedBy, Owner e CostCenter, com suporte a tags adicionais.
- Regras de segurança:
  - Proíbe 0.0.0.0/0 (e ::/0) para qualquer porta além de 443/tcp (validação de variáveis).
  - Exige descrição em todas as regras de entrada e saída.
  - Egress declarado explicitamente; por padrão não há liberação irrestrita.
- VPC configurável por variável.
- Regras de ingress e egress configuráveis por variável.

2. Tabela de variáveis
- region (string, obrigatória): Região AWS onde os recursos serão provisionados.
- environment (string, obrigatória): Ambiente de implantação. Aceita: dev, hml, prd.
- system (string, obrigatória): Identificador do sistema/produto (ex.: tcc). Somente minúsculas, números e hífen (2-32 chars).
- additional_tags (map(string), opcional): Tags adicionais a serem aplicadas. Não pode sobrescrever as tags obrigatórias. Default: {}.
- security_group_name (string, obrigatória): Finalidade do Security Group. Comporá o nome conforme <env>-<system>-sg-<security_group_name>.
- security_group_description (string, opcional): Descrição do Security Group. Default: "Security Group gerenciado por Terraform".
- vpc_id (string, obrigatória): ID da VPC onde o SG será criado (formato vpc-xxxxxxxx).
- ingress_rules (list(object), opcional): Regras de entrada. Cada item exige: description, from_port, to_port, protocol, cidr_blocks, ipv6_cidr_blocks, security_groups, prefix_list_ids. Default: [].
- egress_rules (list(object), opcional): Regras de saída. Cada item exige: description, from_port, to_port, protocol, cidr_blocks, ipv6_cidr_blocks, security_groups, prefix_list_ids. Default: [].

3. Tabela de outputs
- security_group_name: Nome do Security Group criado.
- security_group_arn: ARN do Security Group criado.
- security_group_id: ID do Security Group criado.

4. Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "./"

  region               = "us-east-1"
  environment          = "dev"
  system               = "tcc"
  additional_tags      = { Application = "webapp" }
  security_group_name  = "web"
  security_group_description = "SG para front-end web"
  vpc_id               = "vpc-0123456789abcdef0"

  # Permite HTTPS público e SSH apenas de um bloco corporativo
  ingress_rules = [
    {
      description      = "HTTPS público"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      prefix_list_ids  = []
    },
    {
      description      = "SSH do bloco corporativo"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["203.0.113.0/24"]
      ipv6_cidr_blocks = []
      security_groups  = []
      prefix_list_ids  = []
    }
  ]

  # Egress explícito para HTTPS
  egress_rules = [
    {
      description      = "Saída HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      prefix_list_ids  = []
    }
  ]
}
