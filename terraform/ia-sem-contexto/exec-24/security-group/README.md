Blueprint Terraform: AWS Security Group

Descricao
- Provisiona um Security Group na AWS com foco em configuracao segura por padrao: nenhum ingress e nenhum egress implicito.
- Regras de entrada e saida sao opcionais e controladas por variaveis.
- Compatibilidade: terraform fmt, terraform init -backend=false, terraform validate.

Recursos criados
- aws_security_group
- aws_vpc_security_group_ingress_rule (opcional, conforme variaveis)
- aws_vpc_security_group_egress_rule (opcional, conforme variaveis)

Entrada principal obrigatoria
- vpc_id: ID da VPC alvo.

Variaveis-chave
- aws_region: Regiao AWS (default: us-east-1)
- name, description, tags
- allow_ssh_cidrs, allow_http_cidrs, allow_https_cidrs
- custom_tcp_ports, custom_tcp_cidrs, custom_tcp_ipv6_cidrs
- allow_self_all_ports (intra-SG)
- allow_all_egress, allow_all_egress_ipv6
- egress_cidrs, egress_ipv6_cidrs, egress_protocol, egress_from_port, egress_to_port

Seguranca por padrao
- Ingress: nenhum permitido, a menos que explicitamente configurado.
- Egress: o SG e criado com egress vazio (sem permitir tudo). Habilite saida com as variaveis de egress conforme necessario.

Exemplo de uso
- Cria um SG que permite:
  - SSH somente do seu IP
  - HTTP e HTTPS de qualquer lugar (apenas para testes)
  - Porta customizada 5432/TCP de uma rede privada
  - Egress somente para TCP 443/TCP e 80/TCP para Internet

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "app-sg"

  allow_ssh_cidrs   = ["203.0.113.10/32"]
  allow_http_cidrs  = ["0.0.0.0/0"]
  allow_https_cidrs = ["0.0.0.0/0"]

  custom_tcp_ports      = [5432]
  custom_tcp_cidrs      = ["10.0.0.0/16"]
  custom_tcp_ipv6_cidrs = []

  allow_self_all_ports = true

  # Egress: somente HTTP/HTTPS para Internet
  allow_all_egress       = false
  allow_all_egress_ipv6  = false
  egress_protocol        = "tcp"
  egress_from_port       = 80
  egress_to_port         = 443
  egress_cidrs           = ["0.0.0.0/0"]
  egress_ipv6_cidrs      = []

  tags = {
    Environment = "dev"
    Project     = "example"
  }
}

Saida (outputs)
- security_group_id, security_group_arn, security_group_name, security_group_vpc_id
- IDs das regras criadas: ssh_rule_ids, http_rule_ids, https_rule_ids, custom_tcp_ipv4_rule_ids, custom_tcp_ipv6_rule_ids, self_ingress_rule_id, egress_all_ipv4_rule_id, egress_all_ipv6_rule_id, egress_custom_ipv4_rule_ids, egress_custom_ipv6_rule_ids

Comandos basicos
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Notas
- Evite usar 0.0.0.0/0 em producao, prefira CIDRs restritos.
- Para desabilitar totalmente o egress, mantenha allow_all_egress=false e listas egress_* vazias.
