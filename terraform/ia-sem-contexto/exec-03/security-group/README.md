Terraform AWS Security Group

Visao geral
- Blueprint Terraform para criar um Security Group (SG) na AWS com configuracao segura por padrao.
- Sem regras de ingress por padrao (nega todo trafego de entrada).
- Regras de egress por padrao permitem todo trafego de saida (IPv4 e IPv6), podendo ser restritas via variaveis.

Requisitos
- Terraform >= 1.3.0
- Provider AWS ~> 5.x
- Uma VPC existente (informe o ID via variavel vpc_id)
- Credenciais AWS validas no momento do apply (nao sao necessarias para init/validate)

Arquivos
- main.tf: definicoes do provider, Security Group e regras
- variables.tf: variaveis configuraveis com validacoes
- outputs.tf: saidas relevantes do SG e regras
- versions.tf: versoes minimas e providers
- README.md: instrucoes de uso

Como usar (exemplo simples)
1) Ajuste as variaveis em terraform.tfvars ou via -var:
aws_region = "us-east-1"
vpc_id     = "vpc-0123456789abcdef0"
name       = "web-sg"
description = "SG para workload web"
tags = {
  environment = "dev"
  application = "sample"
}

# Permitir SSH apenas do seu IP e HTTP/HTTPS de qualquer lugar
ingress_rules = [
  {
    description = "SSH from admin IP"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["198.51.100.10/32"]
  },
  {
    description = "HTTP"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description      = "HTTPS"
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
]

# (Opcional) Restringir egress a HTTP/HTTPS apenas
# Substitua o default por:
# egress_rules = [
#   { description = "HTTPS outbound", protocol = "tcp", from_port = 443, to_port = 443, cidr_blocks = ["0.0.0.0/0"] },
#   { description = "HTTP outbound",  protocol = "tcp", from_port = 80,  to_port = 80,  cidr_blocks = ["0.0.0.0/0"] }
# ]

2) Inicialize e valide:
terraform init -backend=false
terraform validate

3) Planeje e aplique:
terraform plan
terraform apply

Modelo de regras
- Cada item em ingress_rules e egress_rules suporta:
  - description: texto descritivo (opcional)
  - protocol: "tcp", "udp", "icmp", "icmpv6" ou "-1" (todos)
  - from_port, to_port: intervalo de portas (para ICMP pode ser -1)
  - cidr_blocks: lista de CIDRs IPv4
  - ipv6_cidr_blocks: lista de CIDRs IPv6
  - prefix_list_ids: lista de Prefix List IDs
  - security_group_ids: lista de SGs a referenciar (ingress usa source_security_group_id; egress usa referenced_security_group_id)
  - self: true/false para referenciar o proprio SG
- As variaveis possuem validacoes basicas de protocolo, portas e presenca de pelo menos um alvo (cidr/ipv6/prefix-list/sg/self).

Decisoes de seguranca por padrao
- Nenhuma regra de ingress por padrao (nega todo trafego de entrada).
- Egress aberto por padrao para facilitar uso geral; restrinja conforme necessidade definindo egress_rules.
- revoke_rules_on_delete = true para garantir limpeza de regras ao destruir o SG.

Saidas
- security_group_id, security_group_arn, security_group_name, vpc_id
- ingress_rule_ids, egress_rule_ids

Notas
- Evite inserir valores sensiveis diretamente no codigo. Utilize variaveis e mecanismos seguros de fornecimento (ex.: variaveis de ambiente, arquivos tfvars fora de controle de versao).
- Este template nao configura backend remoto para facilitar validacao local.
