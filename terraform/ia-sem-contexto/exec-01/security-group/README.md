Blueprint Terraform: AWS Security Group

Descrição
- Provisiona um Security Group em uma VPC específica, com regras de ingress e egress configuráveis via variáveis.
- Por padrão, nenhuma entrada é permitida (ingress vazio) e todo o tráfego de saída é permitido (egress liberado para IPv4 e IPv6).

Requisitos
- Terraform >= 1.3.0
- Provider AWS ~> 5.0
- Uma VPC existente (forneça o vpc_id)

Arquivos
- main.tf: definição do provider e recurso aws_security_group
- variables.tf: variáveis de configuração com validações
- outputs.tf: saídas relevantes do Security Group
- versions.tf: versões mínimas do Terraform e do provider
- README.md: instruções de uso

Como usar (exemplo simples)
1) Defina as variáveis mínimas necessárias (vpc_id). Opcionalmente ajuste name, ingress_rules, egress_rules e tags.
2) Execute:
   terraform init -backend=false
   terraform validate
   terraform plan -var="vpc_id=vpc-1234567890abcdef0"
   terraform apply -var="vpc_id=vpc-1234567890abcdef0"

Exemplo de variáveis (tfvars) para permitir SSH e HTTPS de origens específicas e restringir saída a HTTPS:
aws_region = "us-east-1"
vpc_id     = "vpc-1234567890abcdef0"
name       = "app-sg"

ingress_rules = [
  {
    description      = "SSH from admin IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["203.0.113.10/32"]
    ipv6_cidr_blocks = []
    security_groups  = []
    prefix_list_ids  = []
    self             = false
  },
  {
    description      = "HTTPS from Internet"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_groups  = []
    prefix_list_ids  = []
    self             = false
  }
]

egress_rules = [
  {
    description      = "Egress: HTTPS only"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_groups  = []
    prefix_list_ids  = []
    self             = false
  }
]

tags = {
  environment = "dev"
  project     = "example"
}

Notas
- vpc_id é obrigatório e deve apontar para a VPC alvo.
- ingress_rules padrão é uma lista vazia (nenhuma entrada permitida).
- egress_rules padrão permite todo tráfego de saída (0.0.0.0/0 e ::/0). Ajuste conforme necessário para postura mais restritiva.
- O recurso usa revoke_rules_on_delete = true para revogar regras ao destruir o SG.

Comandos úteis
- Formatação: terraform fmt -recursive
- Inicialização sem backend remoto: terraform init -backend=false
- Validação: terraform validate
- Plano: terraform plan
- Aplicação: terraform apply
- Destruição: terraform destroy
