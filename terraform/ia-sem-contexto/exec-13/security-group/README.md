Nome
Blueprint Terraform para criar um Security Group na AWS.

Visao geral
Este template cria um Security Group em uma VPC especificada, com regras de ingress e egress configuraveis via variaveis. Por padrao, nao ha regras de ingress e egress permite todo o trafego de saida (IPv4 e IPv6). Tags padrao e boas praticas como revoke_rules_on_delete e create_before_destroy sao aplicadas.

Arquivos
- versions.tf: Versoes do Terraform e provider AWS requeridas.
- variables.tf: Variaveis de configuracao e validacoes.
- main.tf: Provider, locals, recurso aws_security_group e regras dinamicas.
- outputs.tf: Informacoes uteis do Security Group.
- README.md: Instrucoes de uso.

Requisitos
- Terraform 1.5.0+.
- Provider AWS 5.x.
- Uma VPC existente (forneca o vpc_id).

Variaveis principais
- aws_region (string): Regiao AWS. Padrao: us-east-1.
- vpc_id (string): ID da VPC (obrigatorio).
- name (string): Nome do Security Group. Padrao: secure-sg.
- description (string): Descricao. Padrao: Managed by Terraform.
- environment (string): dev | test | staging | prod. Padrao: dev.
- tags (map(string)): Tags adicionais. Padrao: {}.
- ingress_rules (list(object)): Regras de entrada. Padrao: [] (nenhuma entrada permitida).
- egress_rules (list(object)): Regras de saida. Padrao: permite tudo (IPv4 e IPv6).

Esquema das regras
Cada objeto de regra possui:
- description (string, opcional)
- protocol (string) [tcp, udp, icmp, icmpv6, -1]
- from_port (number)
- to_port (number)
- cidr_blocks (list(string), opcional)
- ipv6_cidr_blocks (list(string), opcional)
- prefix_list_ids (list(string), opcional)
- security_groups (list(string), opcional)
- self (bool, opcional)

Observacoes
- Para cada regra, ao menos uma origem/destino deve ser definida (cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, security_groups) ou self=true.
- Para permitir SSH somente do seu IP:
  - protocol: tcp
  - from_port: 22
  - to_port: 22
  - cidr_blocks: ["SEU.IP.PUBLICO/32"]

Exemplo de uso
1) Defina as variaveis desejadas (por exemplo, via terraform.tfvars ou -var/-var-file).
2) Execute:
   - terraform init -backend=false
   - terraform validate
   - terraform plan -var 'vpc_id=vpc-0123456789abcdef0'
   - terraform apply -var 'vpc_id=vpc-0123456789abcdef0'

Exemplo de valores (terraform.tfvars)
aws_region = "us-east-1"
vpc_id     = "vpc-0123456789abcdef0"
name       = "app-sg"
environment = "dev"
tags = {
  Project = "sample"
  Owner   = "team-dev"
}

# Ingress: SSH do meu IP e HTTP/HTTPS de qualquer lugar
ingress_rules = [
  {
    description      = "SSH from admin IP"
    protocol         = "tcp"
    from_port        = 22
    to_port          = 22
    cidr_blocks      = ["203.0.113.10/32"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  },
  {
    description      = "HTTP"
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  },
  {
    description      = "HTTPS"
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
]

# Egress: manter padrao (tudo liberado) ou personalizar substituindo a lista
# egress_rules = [
#   {
#     description      = "Somente saida HTTP/HTTPS"
#     protocol         = "tcp"
#     from_port        = 80
#     to_port          = 80
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#     prefix_list_ids  = []
#     security_groups  = []
#     self             = false
#   },
#   {
#     description      = "HTTPS"
#     protocol         = "tcp"
#     from_port        = 443
#     to_port          = 443
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#     prefix_list_ids  = []
#     security_groups  = []
#     self             = false
#   }
# ]

Saida (outputs)
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- security_group_tags

Seguranca por padrao
- Nenhum ingress e criado por padrao.
- Egress padrao permite todo trafego de saida (comportamento comum em SGs). Ajuste egress_rules conforme sua necessidade de restricao.

Notas finais
- Nao ha backend remoto configurado.
- O template nao depende de credenciais reais para validacao sintatica (terraform validate).
- Para aplicar recursos na AWS, configure suas credenciais via variaveis de ambiente ou arquivo de credenciais da AWS CLI.
