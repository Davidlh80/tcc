Nome
Blueprint Terraform - AWS Security Group

Visão geral
Este template cria um Security Group (SG) em uma VPC existente na AWS. Por padrão, não cria regras de entrada nem de saída (postura mais restritiva). Você pode definir regras de ingress e egress conforme necessário.

Requisitos
- Terraform >= 1.3.0
- Provider AWS ~> 5.0
- Credenciais AWS já configuradas no ambiente (ex.: variáveis de ambiente ou perfil local). Não há backend remoto.

Arquivos
- versions.tf: versões mínimas do Terraform e provider.
- variables.tf: variáveis de entrada.
- main.tf: provider e recurso aws_security_group com regras dinâmicas.
- outputs.tf: saídas do SG.
- README.md: instruções e exemplos.

Entradas (variáveis principais)
- region (string): região AWS. Padrão: us-east-1.
- vpc_id (string): ID da VPC onde o SG será criado. Obrigatório.
- name (string): nome do SG. Padrão: sg-managed.
- description (string): descrição do SG. Padrão: Managed by Terraform - Security Group.
- revoke_rules_on_delete (bool): revogar regras antes da deleção. Padrão: true.
- ingress_rules (list(object)): regras de entrada. Padrão: [] (nenhuma).
- egress_rules (list(object)): regras de saída. Padrão: [] (nenhuma).
- tags (map(string)): tags adicionais. Padrão: {}.

Formato das regras
Cada item de ingress_rules e egress_rules deve seguir:
- description: string
- protocol: string (tcp, udp, icmp, icmpv6, ou -1 para qualquer)
- from_port: number
- to_port: number
- ipv4_cidr_blocks: list(string) (ex.: ["10.0.0.0/16"])
- ipv6_cidr_blocks: list(string) (ex.: ["::/0"])

Comportamento padrão
- Sem regras de entrada.
- Sem regras de saída (bloqueio total). Para permitir tráfego de saída comum (ex.: HTTPS), adicione regras em egress_rules.

Exemplos de uso
Exemplo 1: SG sem regras (tudo bloqueado)
module root (usar diretamente neste diretório):
  Defina variáveis mínimas:
    vpc_id = "vpc-0123456789abcdef0"

Execute:
  terraform init -backend=false
  terraform validate
  terraform plan -var="vpc_id=vpc-0123456789abcdef0"

Exemplo 2: Permitir SSH de um bloco específico e HTTPS de saída
terraform apply \
  -var="vpc_id=vpc-0123456789abcdef0" \
  -var='ingress_rules=[{
    description="SSH from office",
    protocol="tcp",
    from_port=22,
    to_port=22,
    ipv4_cidr_blocks=["203.0.113.0/24"],
    ipv6_cidr_blocks=[]
  }]' \
  -var='egress_rules=[{
    description="HTTPS egress",
    protocol="tcp",
    from_port=443,
    to_port=443,
    ipv4_cidr_blocks=["0.0.0.0/0"],
    ipv6_cidr_blocks=["::/0"]
  }]'

Exemplo 3: Permitir todo o egress (não recomendado)
terraform apply \
  -var="vpc_id=vpc-0123456789abcdef0" \
  -var='egress_rules=[{
    description="All egress",
    protocol="-1",
    from_port=0,
    to_port=0,
    ipv4_cidr_blocks=["0.0.0.0/0"],
    ipv6_cidr_blocks=[]
  }]'

Saídas
- security_group_id: ID do SG.
- security_group_arn: ARN do SG.
- security_group_name: nome do SG.
- security_group_vpc_id: VPC do SG.
- ingress_rules_count: quantidade de regras de entrada.
- egress_rules_count: quantidade de regras de saída.

Boas práticas
- Sempre use blocos CIDR mínimos necessários.
- Evite 0.0.0.0/0 e ::/0, especialmente em ingress.
- Versione suas mudanças e faça revisão de pares.

Comandos úteis
- terraform fmt
- terraform init -backend=false
- terraform validate
- terraform plan -var="vpc_id=vpc-XXXXXXXX"
- terraform apply -var="vpc_id=vpc-XXXXXXXX"

Notas
- Este template não configura backend remoto.
- Não há dependência de credenciais reais para validação sintática; no entanto, a aplicação real exige credenciais válidas.
