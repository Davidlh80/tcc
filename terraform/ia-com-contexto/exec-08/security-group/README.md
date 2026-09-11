Visão geral do recurso
Este template provisiona um Security Group seguindo o padrão organizacional:
- Nome: <environment>-<system>-sg-<security_group_name>
- Tags obrigatórias aplicadas a todos os recursos compatíveis
- Regras de segurança:
  - Proíbe 0.0.0.0/0 e ::/0 em qualquer porta além da 443/tcp
  - Exige descrição em toda regra de entrada e saída
  - Egress é explícito e não é liberado por padrão (sem regras, sem saída)

Tabela de variáveis
- region (string) [Obrigatória]: Região AWS onde o Security Group será criado.
- environment (string) [Obrigatória]: Ambiente do recurso (dev, hml, prd).
- system (string) [Obrigatória]: Nome do sistema/aplicação (minúsculas, números e hífens).
- additional_tags (map(string)) [Opcional]: Tags adicionais a serem aplicadas.
- security_group_name (string) [Obrigatória]: Finalidade do Security Group (parte final do nome).
- security_group_description (string) [Opcional]: Descrição do Security Group. Padrão: "Security group for <nome_gerado>".
- vpc_id (string) [Obrigatória]: ID da VPC onde o Security Group será criado.
- ingress_rules (list(object)) [Opcional]: Regras de entrada. Campos:
  - description (string) [Obrigatório]
  - from_port (number) [Obrigatório]
  - to_port (number) [Obrigatório]
  - protocol (string) [Obrigatório]
  - cidr_blocks (list(string)) [Opcional]
  - ipv6_cidr_blocks (list(string)) [Opcional]
- egress_rules (list(object)) [Opcional]: Regras de saída. Declaradas explicitamente (sem padrão permissivo). Campos:
  - description (string) [Obrigatório]
  - from_port (number) [Obrigatório]
  - to_port (number) [Obrigatório]
  - protocol (string) [Obrigatório]
  - cidr_blocks (list(string)) [Opcional]
  - ipv6_cidr_blocks (list(string)) [Opcional]

Tabela de outputs
- security_group_name: Nome do Security Group criado.
- security_group_arn: ARN do Security Group criado.
- security_group_id: ID do Security Group criado.

Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "./"

  region               = "sa-east-1"
  environment          = "dev"
  system               = "tcc"
  security_group_name  = "web"
  vpc_id               = "vpc-0123456789abcdef0"

  additional_tags = {
    Application = "web-frontend"
  }

  # Entrada: Permitir HTTPS (443/tcp) a partir da internet
  ingress_rules = [
    {
      description      = "Allow HTTPS from internet"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  # Saída: Permitir apenas HTTPS (443/tcp) para qualquer destino
  egress_rules = [
    {
      description      = "Allow egress HTTPS"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}
