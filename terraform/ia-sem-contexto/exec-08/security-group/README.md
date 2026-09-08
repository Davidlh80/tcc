Blueprint Terraform — AWS Security Group

Visão geral
Este template cria um Security Group na AWS dentro de uma VPC informada por variável, com regras de entrada e saída configuráveis via variáveis. Padrões seguros priorizados: nenhuma regra de ingresso por padrão e egress liberado (customizável).

Requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Uma VPC existente (vpc_id)

Arquivos
- main.tf: definição do provider e do recurso aws_security_group.
- variables.tf: variáveis de entrada com validações.
- outputs.tf: saídas úteis (id, arn, nome, vpc_id, regras efetivas).
- versions.tf: versões mínimas do Terraform e provider.
- README.md: instruções de uso.

Variáveis principais
- aws_region (string): Região AWS. Padrão: us-east-1
- vpc_id (string): ID da VPC alvo. Obrigatória.
- name (string|null): Nome fixo do SG. Se nulo, usa name_prefix.
- name_prefix (string): Prefixo para nome do SG quando name é nulo. Padrão: tf-sg-
- description (string): Descrição do SG. Padrão: Security Group gerenciado por Terraform
- revoke_rules_on_delete (bool): Revogar regras em delete. Padrão: true
- ingress_rules (list(object)): Regras de entrada. Padrão: []
- egress_rules (list(object)): Regras de saída. Padrão: permite toda saída IPv4 e IPv6.
- tags (map(string)): Tags adicionais.

Estrutura das regras (ingress_rules e egress_rules)
Cada item é um objeto com:
- from_port (number), to_port (number), protocol (string)
- description (string, opcional)
- cidr_blocks (list(string), opcional)
- ipv6_cidr_blocks (list(string), opcional)
- prefix_list_ids (list(string), opcional)
- security_groups (list(string), opcional)
- self (bool, opcional)

Observação: pelo menos uma origem/destino deve ser especificada em cada regra (ex.: cidr_blocks, ipv6_cidr_blocks, security_groups ou self = true).

Exemplos de uso
1) SG básico sem ingress (somente egress padrão):
variables.tfvars (exemplo)
vpc_id     = "vpc-0123456789abcdef0"
aws_region = "us-east-1"

2) Permitir SSH do seu IP e HTTP público:
variables.tfvars (exemplo)
vpc_id     = "vpc-0123456789abcdef0"
aws_region = "us-east-1"
name       = "app-sg"
ingress_rules = [
  {
    description = "SSH da minha origem"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.10/32"]
  },
  {
    description = "HTTP público"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
]

Como executar
- Exporte suas credenciais AWS por variáveis de ambiente antes de aplicar (ex.: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION), ou use um método de autenticação suportado pelo provider.
- Comandos:
  terraform init -backend=false
  terraform validate
  terraform plan -var-file="variables.tfvars"
  terraform apply -var-file="variables.tfvars"

Saídas
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- security_group_ingress_effective
- security_group_egress_effective

Boas práticas
- Restrinja ingress ao mínimo necessário e prefira CIDRs específicos (ex.: /32) quando adequado.
- Use tags para facilitar governança e rastreabilidade.
- Revise periodicamente as regras para garantir o princípio do menor privilégio.
