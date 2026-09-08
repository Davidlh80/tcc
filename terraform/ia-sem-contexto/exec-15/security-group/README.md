Blueprint Terraform: AWS Security Group

Descrição
- Provisiona um Security Group na AWS com foco em configurações seguras por padrão.
- Nenhuma regra é criada por padrão (sem ingress e sem egress), cabendo ao usuário definir explicitamente as regras necessárias.
- Regras são gerenciadas por recursos aws_security_group_rule separados, evitando recriação do Security Group em mudanças de regras.

Requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Uma VPC existente na conta (informe via variável vpc_id)
- Credenciais válidas AWS no ambiente apenas para execução de terraform plan/apply (não são necessárias para terraform validate)

Como usar (exemplo)
module "security_group" {
  source = "./"

  region      = "us-east-1"
  vpc_id      = "vpc-0123456789abcdef0"
  name        = "web-sg"
  description = "Security Group para workload web"

  # Exemplo: permitir HTTPS de qualquer lugar (IPv4 e IPv6)
  ingress_rules = [
    {
      description      = "HTTPS da Internet"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  # Exemplo: saída apenas HTTPS (mais seguro que liberar tudo)
  egress_rules = [
    {
      description = "Saída HTTPS"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "dev"
    Owner       = "team-example"
  }
}

Variáveis
- region (string): Região AWS. Padrão: us-east-1.
- vpc_id (string): ID da VPC onde o SG será criado. Obrigatória.
- name (string): Nome do Security Group. Padrão: sg-example.
- description (string): Descrição do Security Group. Padrão: Security Group gerenciado por Terraform.
- tags (map(string)): Tags adicionais para o SG. Padrão: {}.
- ingress_rules (list(object)): Lista de regras de entrada.
- egress_rules (list(object)): Lista de regras de saída.

Esquema de regra (ingress_rules/egress_rules)
Cada item da lista é um objeto com os campos:
- description (string, opcional): Descrição da regra.
- protocol (string, obrigatório): tcp, udp, icmp, icmpv6 ou -1 (todos).
- from_port (number, obrigatório): Porta inicial (usar -1 para ICMP todos).
- to_port (number, obrigatório): Porta final (usar -1 para ICMP todos).
- cidr_blocks (list(string), opcional): Lista de CIDRs IPv4.
- ipv6_cidr_blocks (list(string), opcional): Lista de CIDRs IPv6.
- prefix_list_ids (list(string), opcional): Lista de AWS Prefix Lists (tipicamente usado em egress).
- self (bool, opcional): true para permitir tráfego para/da própria SG.

Observações
- Por padrão, nenhuma regra é criada (sem ingress e sem egress). Defina explicitamente as regras necessárias.
- prefix_list_ids geralmente é válido para egress. Use conforme suporte/necessidade do seu caso.
- Utilize regras o mais restritivas possível (CIDRs específicos, portas mínimas necessárias).
- Para permitir comunicação interna entre instâncias do mesmo SG, defina uma regra com self=true.

Outputs
- security_group_id: ID do Security Group.
- security_group_arn: ARN do Security Group.
- security_group_name: Nome do Security Group.
- security_group_vpc_id: VPC do Security Group.
- ingress_rule_ids: IDs das regras de entrada criadas.
- egress_rule_ids: IDs das regras de saída criadas.

Comandos úteis
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Boas práticas de segurança
- Evite 0.0.0.0/0 e ::/0 em ingress, exceto quando estritamente necessário.
- Prefira portas e protocolos específicos; evite -1 (todos) sem justificativa.
- Versão as mudanças deste blueprint em controle de versão e utilize revisões de PR.
