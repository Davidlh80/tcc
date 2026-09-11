Visão geral do recurso
Este template cria um Security Group na AWS seguindo os padrões organizacionais:
- Nomenclatura: <environment>-<system>-sg-<security_group_name>
- Tags obrigatórias aplicadas em todos os recursos
- Regras de segurança:
  - Proíbe 0.0.0.0/0 (e ::/0) em qualquer porta além de 443/tcp
  - Toda regra de entrada e saída exige descrição
  - Egress declarado explicitamente; por padrão, nenhuma saída é permitida
- Regras de entrada e saída configuráveis via variáveis

Tabela de variáveis
- environment (string) [obrigatória]: Ambiente do recurso (dev, hml, prd).
- system (string) [obrigatória]: Nome do sistema/aplicação (minúsculas, números e hífens).
- region (string) [obrigatória]: Região AWS (ex.: us-east-1).
- additional_tags (map(string)) [opcional]: Tags adicionais; tags obrigatórias são preservadas.
- security_group_name (string) [obrigatória]: Finalidade do Security Group (parte final do nome).
- security_group_description (string) [opcional]: Descrição do Security Group. Padrão: "Security Group gerenciado por Terraform".
- vpc_id (string) [obrigatória]: ID da VPC onde o Security Group será criado.
- ingress_rules (list(object)) [opcional]: Regras de entrada. Cada regra requer:
  - description (string)
  - from_port (number)
  - to_port (number)
  - protocol (string: tcp, udp, icmp, icmpv6, -1)
  - ipv4_cidrs (list(string), opcional)
  - ipv6_cidrs (list(string), opcional)
  - prefix_list_ids (list(string), opcional)
  - referenced_security_group_ids (list(string), opcional)
  Observações: Pelo menos um destino deve ser informado por regra. Se usar 0.0.0.0/0 ou ::/0, somente 443/tcp é permitido.
- egress_rules (list(object)) [opcional]: Regras de saída. Mesma estrutura de ingress_rules. Observações: Por padrão, nenhuma saída é permitida; se usar 0.0.0.0/0 ou ::/0, somente 443/tcp é permitido.

Tabela de outputs
- security_group_name: Nome do Security Group criado.
- security_group_arn: ARN do Security Group criado.
- security_group_id: ID do Security Group criado.

Exemplo de uso
module "sg_web" {
  source = "./"

  environment              = "hml"
  system                   = "tcc"
  region                   = "us-east-1"
  security_group_name      = "web"
  security_group_description = "SG para camada web (HTTPS inbound; egress restrito)"
  vpc_id                   = "vpc-0123456789abcdef0"

  additional_tags = {
    Application = "portal-web"
  }

  ingress_rules = [
    {
      description = "Permitir HTTPS público"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      ipv4_cidrs  = ["0.0.0.0/0"]
      ipv6_cidrs  = ["::/0"]
    },
    {
      description = "Permitir healthcheck do ALB"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      referenced_security_group_ids = ["sg-abcdef01234567890"]
    }
  ]

  egress_rules = [
    {
      description = "Permitir saída HTTPS para Internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      ipv4_cidrs  = ["0.0.0.0/0"]
    }
  ]
}
