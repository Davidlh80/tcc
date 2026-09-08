Blueprint Terraform: AWS Security Group

Descrição
- Cria um Security Group em uma VPC específica.
- Padrão seguro: sem regras de egress predefinidas (nenhuma saída é permitida até ser explicitamente liberada); sem regras de ingress por padrão.
- Regras de ingress/egress são definidas via aws_security_group_rule, suportando CIDRs IPv4/IPv6, prefix lists e referência a outros Security Groups.

Pré-requisitos
- Terraform >= 1.3
- Provider AWS ~> 5.0
- Uma VPC existente (forneça vpc_id)
- Credenciais AWS disponíveis no ambiente apenas para aplicar (não necessárias para terraform validate)

Arquivos
- versions.tf: versões mínimas de Terraform e provider.
- variables.tf: variáveis configuráveis com validações.
- main.tf: provider, security group e regras.
- outputs.tf: saídas úteis.
- README.md: instruções.

Variáveis principais
- region: região AWS (ex.: us-east-1).
- vpc_id: ID da VPC alvo (ex.: vpc-0123456789abcdef0).
- name: nome do SG.
- description: descrição do SG.
- tags: mapa de tags adicionais.
- ingress_rules: lista de objetos de regra de entrada.
- egress_rules: lista de objetos de regra de saída.

Estrutura das regras
Cada item das listas ingress_rules/egress_rules possui:
- description (opcional)
- protocol (ex.: tcp, udp, icmp, -1)
- from_port (ex.: 22)
- to_port (ex.: 22)
- cidr_blocks (lista de CIDRs IPv4)
- ipv6_cidr_blocks (lista de CIDRs IPv6)
- prefix_list_ids (lista de prefix lists AWS)
- peer_security_group_ids (lista de SGs para origem/destino)
- self (apenas em ingress; booleano)

Observações de segurança
- Por padrão, egress é fechado. Adicione egress_rules conforme necessário.
- Evite uso de 0.0.0.0/0 e ::/0 em ingress, a menos que seja indispensável e com mitigação adicional.

Exemplo de uso (minimizado)
terraform init -backend=false
terraform validate
terraform plan -var="region=us-east-1" -var="vpc_id=vpc-0123456789abcdef0"

Exemplo de variáveis
region = "us-east-1"
vpc_id = "vpc-0123456789abcdef0"
name   = "app-web-sg"

# Libera SSH apenas de um bloco corporativo e HTTP público para teste
ingress_rules = [
  {
    description      = "SSH corporativo"
    protocol         = "tcp"
    from_port        = 22
    to_port          = 22
    cidr_blocks      = ["203.0.113.0/24"]
  },
  {
    description      = "HTTP público (apenas para teste)"
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
]

# Permite saída somente para HTTPS (IPv4 e IPv6)
egress_rules = [
  {
    description      = "HTTPS outbound"
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
]

Saídas
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- ingress_rule_ids
- egress_rule_ids

Comandos úteis
- terraform init -backend=false
- terraform fmt
- terraform validate
- terraform plan
- terraform apply

Notas
- Não há backend remoto configurado.
- Os valores sensíveis devem vir via variáveis/ambiente.
