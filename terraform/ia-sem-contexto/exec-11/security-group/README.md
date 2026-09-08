Blueprint Terraform: AWS Security Group

Descrição
Este template provisiona um Security Group (SG) na AWS com foco em configurações seguras por padrão:
- Nenhuma regra de entrada (ingress) por padrão.
- Uma regra de saída (egress) padrão permitindo somente HTTPS (443) para IPv4 e IPv6.
- Regras adicionais totalmente configuráveis via variável "rules".

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS ~> 5.x
- Credenciais AWS configuradas no ambiente (para aplicar de fato). Para validação sintática, não são necessárias credenciais.

Arquivos
- versions.tf: versões mínimas do Terraform e provider.
- variables.tf: variáveis configuráveis com validações.
- main.tf: provider, SG e regras.
- outputs.tf: saídas úteis.
- README.md: instruções básicas.

Variáveis principais
- aws_region (string): Região da AWS. Padrão: us-east-1.
- vpc_id (string): ID da VPC onde o SG será criado. Obrigatório.
- name (string): Nome do SG. Padrão: sg-app.
- description (string): Descrição do SG. Padrão: Security Group gerenciado pelo Terraform.
- tags (map(string)): Tags adicionais.
- rules (list(object)): Regras de ingress/egress.

Estrutura de uma regra em rules
- description (opcional): Descrição da regra.
- type: ingress ou egress.
- protocol: tcp | udp | icmp | icmpv6 | -1.
- from_port: número da porta inicial (0-65535).
- to_port: número da porta final (0-65535).
- UMA origem/destino por regra entre:
  - cidr_blocks (opcional, lista IPv4) e/ou ipv6_cidr_blocks (opcional, lista IPv6)
  - OU prefix_list_ids (opcional, lista)
  - OU source_security_group_id (opcional, SG alvo/origem)
  - OU self = true

Exemplo mínimo de uso (terraform.tfvars)
aws_region = "us-east-1"
vpc_id     = "vpc-0123456789abcdef0"
name       = "sg-web"

# Manter apenas egress HTTPS padrão (definido em variables.tf) ou adicionar regras:
rules = [
  {
    description  = "Permite SSH de rede de bastion"
    type         = "ingress"
    protocol     = "tcp"
    from_port    = 22
    to_port      = 22
    cidr_blocks  = ["203.0.113.0/24"]
  },
  {
    description       = "Permite HTTP de um ALB (exemplo com SG como origem)"
    type              = "ingress"
    protocol          = "tcp"
    from_port         = 80
    to_port           = 80
    source_security_group_id = "sg-0abc123def4567890"
  }
]

Comandos úteis
- terraform fmt
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Saídas (outputs)
- security_group_id: ID do SG.
- security_group_arn: ARN do SG.
- security_group_name: Nome do SG.
- security_group_vpc_id: VPC do SG.
- security_group_rules_count: Quantidade de regras.
- security_group_rules: Regras aplicadas (eco da variável).

Notas
- revoke_rules_on_delete = true ajuda a evitar dependências pendentes ao destruir o SG.
- Por padrão, não há ingress permitido; ajuste a variável rules conforme sua necessidade.
