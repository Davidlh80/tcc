Blueprint Terraform — AWS Security Group

Visão geral
- Cria um Security Group em uma VPC específica.
- Padrão seguro: sem regras de entrada e sem regras de saída (nega todo tráfego).
- Possibilidade de habilitar saída liberada (allow_all_egress) e de adicionar regras de entrada por CIDR para SSH/HTTP/HTTPS ou personalizadas.

Arquivos
- versions.tf: versões mínimas do Terraform e do provider AWS.
- variables.tf: variáveis configuráveis e validações.
- main.tf: provider, lógica de composição de regras e recursos.
- outputs.tf: saídas úteis (ID, ARN, contadores, etc.).

Requisitos
- Terraform >= 1.5.0
- Provider AWS >= 5.0
- Uma VPC existente (fornecer vpc_id).

Como usar (exemplo)
1) Configure variáveis principais:
- vpc_id (obrigatória)
- opcionalmente: region, name, description, tags

2) Opcional: libere entradas comuns por CIDR:
- allow_ssh_from_cidrs = ["10.0.0.0/8"]
- allow_http_from_cidrs = ["0.0.0.0/0"]
- allow_https_from_cidrs = ["203.0.113.0/24"]

3) Opcional: adicione regras de entrada personalizadas:
- additional_ingress_rules = [
    {
      description      = "TCP 5432 from corp"
      protocol         = "tcp"
      from_port        = 5432
      to_port          = 5432
      cidr_blocks      = ["10.20.0.0/16"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
    }
  ]

4) Opcional: libere saída (por padrão é bloqueada):
- allow_all_egress = true
- egress_cidr_blocks = ["0.0.0.0/0"]            (IPv4)
- egress_ipv6_cidr_blocks = ["::/0"]            (IPv6) se necessário

Execução
- terraform init -backend=false
- terraform validate
- terraform plan -var="vpc_id=vpc-xxxxxxxx"
- terraform apply -var="vpc_id=vpc-xxxxxxxx"

Variáveis principais
- region: região AWS (padrão: us-east-1).
- name: nome do Security Group (padrão: sg-app).
- description: descrição do SG.
- vpc_id: ID da VPC onde o SG será criado.
- allow_ssh_from_cidrs: lista de CIDRs para TCP/22.
- allow_http_from_cidrs: lista de CIDRs para TCP/80.
- allow_https_from_cidrs: lista de CIDRs para TCP/443.
- additional_ingress_rules: regras ingress adicionais (por CIDR/IPv6/prefix list).
- allow_all_egress: se true, cria regras de saída para todos os protocolos.
- egress_cidr_blocks: CIDRs IPv4 para saída quando allow_all_egress=true.
- egress_ipv6_cidr_blocks: CIDRs IPv6 para saída quando allow_all_egress=true.
- tags: mapa de tags adicionais.

Padrões de segurança
- Sem entradas liberadas por padrão.
- Sem saídas liberadas por padrão (egress explícito vazio no recurso principal).
- revoke_rules_on_delete = true para remoção ordeira das regras.

Saídas
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- ingress_rules_count
- egress_rules_count

Notas
- Esta blueprint não cria nem gerencia outros recursos de rede (subnets, roteadores etc.).
- Regras de entrada com Security Group de origem não estão incluídas; use CIDR ou prefix lists.
