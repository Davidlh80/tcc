Visão geral do recurso
Este template provisiona um Security Group na AWS com foco em segurança e padronização corporativa. Atende aos seguintes controles:
- Nome segue o padrão <ambiente>-<sistema>-sg-<finalidade>.
- VPC configurável por variável.
- Proíbe 0.0.0.0/0 (e ::/0) em qualquer porta além da 443/tcp.
- Exige descrição em todas as regras de entrada e saída.
- Egress declarado explicitamente, sem liberação irrestrita por padrão.
- Tags obrigatórias aplicadas e possibilidade de tags adicionais.

Tabela de variáveis
- environment (string, obrigatório): Ambiente alvo (dev, hml, prd).
- system (string, obrigatório): Identificador do sistema (minúsculo, números e hifens).
- region (string, obrigatório): Região AWS, ex.: sa-east-1.
- additional_tags (map(string), opcional): Tags adicionais a serem mescladas às tags padrão.
- vpc_id (string, obrigatório): ID da VPC onde o Security Group será criado.
- security_group_name (string, obrigatório): Finalidade/nome lógico do SG (parte final do padrão).
- security_group_description (string, opcional): Descrição do Security Group (padrão: Security Group gerenciado por Terraform).
- ingress_rules (list(object), opcional): Regras de entrada. Cada item deve conter:
  - description (string, obrigatório)
  - from_port (number, obrigatório)
  - to_port (number, obrigatório)
  - protocol (string, obrigatório; um de: tcp, udp, icmp, -1)
  - cidr_blocks (list(string), opcional)
  - ipv6_cidr_blocks (list(string), opcional)
  - security_groups (list(string), opcional)
  Observações: pelo menos um destino (cidr_blocks, ipv6_cidr_blocks ou security_groups) deve ser informado; 0.0.0.0/0 e ::/0 são permitidos somente em tcp 443.
- egress_rules (list(object), opcional): Regras de saída. Mesma estrutura e validações de ingress_rules. Por padrão é vazio (nenhuma saída liberada).

Tabela de outputs
- security_group_name: Nome do Security Group.
- security_group_arn: ARN do Security Group.
- security_group_id: ID do Security Group.

Exemplo de uso do módulo/recurso
module "sg_example" {
  source = "./"

  region              = "sa-east-1"
  environment         = "dev"
  system              = "tcc"
  vpc_id              = "vpc-0123456789abcdef0"
  security_group_name = "web"
  security_group_description = "SG para workload web com regras mínimas"

  additional_tags = {
    Application = "web-frontend"
  }

  # Ingress: libera HTTPS público (exceção permitida) e SSH apenas de um bastion
  ingress_rules = [
    {
      description      = "HTTPS público"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
    },
    {
      description      = "SSH do bastion"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.0/8"]
      ipv6_cidr_blocks = []
      security_groups  = []
    }
  ]

  # Egress: libera apenas HTTPS para a Internet e DNS UDP interno
  egress_rules = [
    {
      description      = "Saída HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
    },
    {
      description      = "DNS interno UDP 53"
      from_port        = 53
      to_port          = 53
      protocol         = "udp"
      cidr_blocks      = ["10.0.0.0/8"]
      ipv6_cidr_blocks = []
      security_groups  = []
    }
  ]
}

Após salvar os arquivos, execute:
- terraform init -backend=false
- terraform validate
- terraform apply (exige credenciais AWS válidas no ambiente)
