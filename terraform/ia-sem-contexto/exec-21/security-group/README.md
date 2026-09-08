AWS Security Group — Terraform Blueprint

Descrição
- Cria um Security Group em uma VPC específica usando o provider AWS.
- Regras configuráveis para ingress e egress via variáveis.
- Padrões seguros: nenhum ingress por padrão; egress padrão permitindo todo tráfego de saída (pode ser ajustado).
- Sem backend remoto, adequado para validação local.

Arquivos
- main.tf: definição do Security Group e regras dinâmicas.
- variables.tf: variáveis de entrada com validações.
- outputs.tf: saídas úteis do recurso criado.
- versions.tf: requisitos de versão do Terraform e provider AWS.
- README.md: instruções de uso.

Pré-requisitos
- Terraform 1.3.0 ou superior.
- Provider AWS (~> 5.x).
- Credenciais AWS configuradas no ambiente para aplicar (não necessárias para validação sintática).

Variáveis principais
- region: Região AWS (padrão: us-east-1).
- vpc_id: ID da VPC alvo (obrigatório).
- sg_name: Nome do Security Group (padrão: secure-sg).
- sg_description: Descrição (padrão: Security Group gerenciado pelo Terraform).
- tags: Tags adicionais (mapa string -> string).
- ingress_rules: Lista de regras de entrada (vazia por padrão).
- egress_rules: Lista de regras de saída (por padrão, permite tudo para IPv4 e IPv6).

Formato das regras
Cada item de ingress_rules e egress_rules:
- description: string opcional.
- from_port: número (0–65535).
- to_port: número (>= from_port, <= 65535).
- protocol: tcp, udp, icmp, icmpv6, -1 (all).
- cidr_blocks: lista de CIDRs IPv4.
- ipv6_cidr_blocks: lista de CIDRs IPv6.
- security_groups: lista de IDs de SG (origem em ingress, destino em egress).
- prefix_list_ids: lista de Prefix Lists (usado em egress).
- self: bool (apenas aplicável a ingress; ignorado em egress).

Observações
- Regras sem nenhuma origem/destino definido são ignoradas automaticamente.
- Se usar protocolo -1, use from_port/to_port = 0 conforme recomendado pela AWS.
- O atributo self só é aplicado a regras de ingress.

Exemplos de uso
1) Security Group sem ingress (somente egress default):
- Defina vpc_id e aplique.

2) Permitir SSH de um CIDR específico e HTTPS de outro:
- Defina em terraform.tfvars (exemplo):
vpc_id = "vpc-1234567890abcdef0"
sg_name = "app-sg"
ingress_rules = [
  {
    description  = "SSH de admin"
    from_port    = 22
    to_port      = 22
    protocol     = "tcp"
    cidr_blocks  = ["203.0.113.0/24"]
  },
  {
    description      = "HTTPS público"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
]
tags = {
  environment = "test"
  project     = "sg-blueprint"
}

Comandos úteis
- terraform fmt
- terraform init -backend=false
- terraform validate
- terraform plan -var="vpc_id=vpc-1234567890abcdef0"
- terraform apply -var-file="terraform.tfvars"

Saídas
- security_group_id: ID do SG.
- security_group_arn: ARN do SG.
- security_group_name: Nome do SG.
- security_group_vpc_id: VPC associada.
- ingress_rules_applied: Quantidade de regras de ingress aplicadas.
- egress_rules_applied: Quantidade de regras de egress aplicadas.

Boas práticas
- Restringir ingress ao mínimo necessário (por CIDR e portas específicas).
- Ajustar egress_rules para saída mínima necessária quando aplicável.
- Versionar e revisar alterações em regras de SG (controle de mudanças).
