Blueprint Terraform: AWS Security Group

Descricao
- Provisiona um Security Group na AWS dentro de uma VPC informada por variavel.
- Sem regras por padrao (ingress e egress vazios), privilegiando seguranca; defina regras conforme necessidade.
- Inclui validacoes basicas de variaveis e tags personalizaveis.

Arquivos
- versions.tf: restricoes de versao do Terraform e provider AWS.
- variables.tf: variaveis de configuracao e validacoes.
- main.tf: provider e recurso aws_security_group com suporte a regras dinamicas.
- outputs.tf: saidas principais do recurso.
- README.md: instrucoes de uso.

Requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Uma VPC existente (vpc_id)

Como usar (exemplo)
1) Crie um arquivo terraform.tfvars (ou passe via -var/-var-file) com os valores desejados, por exemplo:

region   = "us-east-1"
vpc_id   = "vpc-0abc123def4567890"
name     = "sg-app-example"
tags = {
  Environment = "dev"
  Owner       = "example"
}

# Regras de entrada: permitir SSH apenas do seu IP
ingress_rules = [
  {
    description      = "SSH from office"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["203.0.113.10/32"]
    ipv6_cidr_blocks = []
    security_groups  = []
    self             = false
  }
]

# Regras de saida: permitir HTTP/HTTPS para qualquer destino IPv4
egress_rules = [
  {
    description      = "HTTP egress"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = []
    prefix_list_ids  = []
  },
  {
    description      = "HTTPS egress"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = []
    prefix_list_ids  = []
  }
]

2) Comandos:
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Variaveis principais
- region (string): Regiao AWS. Padrao: us-east-1.
- vpc_id (string): ID da VPC alvo (obrigatorio).
- name (string): Nome do SG e da tag Name. Padrao: sg-managed.
- description (string): Descricao do SG. Padrao: Security Group gerenciado por Terraform.
- tags (map(string)): Tags adicionais a aplicar.
- revoke_rules_on_delete (bool): Revoga regras antes da remocao. Padrao: true.
- ingress_rules (list(object)):
  - description (string) opcional
  - from_port (number)
  - to_port (number)
  - protocol (string): -1, tcp, udp, icmp, icmpv6
  - cidr_blocks (list(string)) opcional
  - ipv6_cidr_blocks (list(string)) opcional
  - security_groups (list(string)) opcional
  - self (bool) opcional
- egress_rules (list(object)):
  - description (string) opcional
  - from_port (number)
  - to_port (number)
  - protocol (string): -1, tcp, udp, icmp, icmpv6
  - cidr_blocks (list(string)) opcional
  - ipv6_cidr_blocks (list(string)) opcional
  - security_groups (list(string)) opcional
  - prefix_list_ids (list(string)) opcional (apenas egress)

Saidas
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id

Observacoes
- Este template nao configura backend remoto.
- O provider e inicializado sem exigir credenciais para validacao sintatica local.
- Por padrao, nenhuma regra e criada; defina ingress_rules/egress_rules conforme sua necessidade.
