Nome
- Terraform AWS Security Group (SG) — blueprint mínima, segura por padrão.

Descrição
- Cria um Security Group em uma VPC específica.
- Sem regras de egress por padrão (nega tudo na saída).
- Regras de ingress e egress opcionais e declaradas via variáveis.
- Variáveis com validações básicas e tags suportadas.

Requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Uma VPC existente (vpc_id obrigatório)

Arquivos
- versions.tf: versões e providers.
- variables.tf: variáveis de entrada com validações.
- main.tf: provider, recursos e regras.
- outputs.tf: saídas úteis.
- README.md: instruções.

Entradas principais
- aws_region (string): região AWS. Padrão: us-east-1
- vpc_id (string): ID da VPC. Ex.: vpc-0123456789abcdef0
- name (string): nome do SG. Padrão: secure-sg
- sg_description (string): descrição do SG.
- enable_name_tag (bool): adiciona tag Name. Padrão: true
- tags (map(string)): tags adicionais.
- ingress_rules (list(object)): regras de entrada.
- egress_rules (list(object)): regras de saída.

Observações de segurança
- Egress é negado por padrão (egress = []). Defina egress_rules conforme necessário.
- Evite usar 0.0.0.0/0 e ::/0 em ingress, a menos que seja estritamente necessário.

Exemplos de uso
1) SG sem regras (tudo negado)
- Cria o SG e não adiciona regras de ingress/egress (nenhuma conectividade).
variables.tfvars (exemplo)
vpc_id = "vpc-0123456789abcdef0"

2) Permitir HTTP de um bloco corporativo e saída somente para HTTP/HTTPS
variables.tfvars (exemplo)
vpc_id = "vpc-0123456789abcdef0"

ingress_rules = [
  {
    description      = "HTTP de corp"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["203.0.113.0/24"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    source_security_group_id = ""
  }
]

egress_rules = [
  {
    description      = "Saída HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
  },
  {
    description      = "Saída HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
  }
]

3) Ingress a partir de outro Security Group (ex.: tráfego interno)
variables.tfvars (exemplo)
vpc_id = "vpc-0123456789abcdef0"

ingress_rules = [
  {
    description              = "Tráfego interno app"
    from_port                = 8080
    to_port                  = 8080
    protocol                 = "tcp"
    cidr_blocks              = []
    ipv6_cidr_blocks         = []
    prefix_list_ids          = []
    source_security_group_id = "sg-0abc123def4567890"
  }
]

Como executar
- Formatar: terraform fmt
- Inicializar (sem backend remoto): terraform init -backend=false
- Validar: terraform validate
- Plano: terraform plan -var="vpc_id=vpc-0123456789abcdef0"
- Aplicar: terraform apply -var-file="variables.tfvars"

Saídas
- security_group_id: ID do SG.
- security_group_arn: ARN do SG.
- security_group_name: Nome do SG.
- ingress_rule_ids: mapa com IDs das regras de ingresso.
- egress_rule_ids: mapa com IDs das regras de saída.

Notas
- Não há backend remoto configurado.
- Nenhuma credencial real é necessária para validação sintática.
- Para permitir egress total, adicione uma regra em egress_rules com protocolo -1, from_port = 0, to_port = 0 e cidr_blocks = ["0.0.0.0/0"] (ou ipv6 "::/0" se aplicável).
