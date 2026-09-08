Blueprint Terraform: AWS Security Group

Visão geral
- Este template cria um Security Group (SG) em uma VPC específica na AWS, com foco em padrões seguros por padrão: sem regras de entrada e regras de saída explícitas permitindo tráfego para qualquer destino (comportamento comum e stateful).
- Regras de entrada e saída podem ser personalizadas via variáveis.

Recursos criados
- aws_security_group.this

Padrões de segurança
- Entrada: nenhuma regra por padrão (tudo bloqueado).
- Saída: duas regras explícitas permitindo todo tráfego IPv4 e IPv6 (comportamento típico de SG). Ajuste conforme necessário.

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Uma VPC existente (vpc_id)

Como usar (exemplo mínimo)
- Defina as seguintes variáveis:
  - aws_region: ex. us-east-1
  - vpc_id: ex. vpc-1234567890abcdef0
- Opcionalmente ajuste name, description, tags e listas de ingress_rules/egress_rules.

Exemplo de variáveis comuns
- name: my-app-sg
- description: SG da minha aplicação
- tags:
  - Environment = dev
  - Project = sample

Estrutura de regras
- Cada item de ingress_rules ou egress_rules aceita as chaves abaixo (use apenas as que fizerem sentido para sua regra):
  - description: string
  - from_port: number (ex.: 22, 80, 443; use 0 com protocol -1 para qualquer porta)
  - to_port: number
  - protocol: string (ex.: tcp, udp, icmp, -1 para qualquer protocolo)
  - cidr_blocks: lista de CIDRs IPv4 (ex.: ["10.0.0.0/16"])
  - ipv6_cidr_blocks: lista de CIDRs IPv6 (ex.: ["::/0"])
  - security_groups: lista de IDs de SG (ex.: ["sg-0123456789abcdef0"])
  - prefix_list_ids: lista de IDs de prefix list (ex.: ["pl-12345678"])

Exemplos práticos de regras
- Permitir SSH somente de um bloco IPv4 específico (entrada):
  - ingress_rules = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["203.0.113.0/24"]
    }
  ]
- Restringir saída apenas para HTTP/HTTPS:
  - egress_rules = [
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

Observações
- O Security Group é stateful: tráfego de retorno é automaticamente permitido.
- Se nenhuma regra de egress_rules for fornecida, o código define explicitamente duas regras de saída amplas (IPv4 e IPv6). Ajuste para seu caso de uso.
- Evite usar 0.0.0.0/0 e ::/0 em ingress_rules, a menos que absolutamente necessário.

Comandos úteis
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Saídas
- security_group_id: ID do SG
- security_group_arn: ARN do SG
- security_group_name: Nome do SG
- security_group_vpc_id: ID da VPC do SG
- ingress_rules_count: Número de regras de entrada aplicadas
- egress_rules_count: Número de regras de saída aplicadas
