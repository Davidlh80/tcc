Blueprint Terraform: AWS Security Group

Descricao
- Cria um Security Group em uma VPC especificada.
- Por padrao, nao ha regras de entrada e TODA saida e bloqueada (egress = []). Isso prioriza seguranca por padrao.
- Regras de ingress e egress podem ser definidas por variaveis, com suporte a IPv4, IPv6 e referencia a outros Security Groups.

Arquivos
- versions.tf: Versoes do Terraform e provider.
- variables.tf: Variaveis de configuracao.
- main.tf: Provider, recursos e logica de regras.
- outputs.tf: Atributos exportados.
- README.md: Este guia.

Pre-requisitos
- Terraform >= 1.3
- Provider AWS ~> 5.x
- Uma VPC existente (var.vpc_id)

Como usar (exemplo simples)
1) Defina as variaveis minimas (vpc_id). Opcionalmente ajuste nome/tags e regras:
  aws_region = "us-east-1"
  vpc_id     = "vpc-0123456789abcdef0"

2) Exemplos de regras

- Liberar SSH (22/tcp) de um CIDR especifico:
  ingress_rules = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["203.0.113.10/32"]
    }
  ]

- Liberar HTTP(80) e HTTPS(443) para o mundo (nao recomendado em ambientes sensiveis; use com cautela):
  ingress_rules = [
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0", "::/0"]
    },
    {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0", "::/0"]
    }
  ]

- Referenciar outro Security Group como origem de ingress (mesma VPC):
  ingress_rules = [
    {
      description     = "App to DB"
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = ["sg-0123456789abcdef0"]
    }
  ]

- Permitir toda saida (egress) IPv4 e IPv6 (use conscientemente):
  egress_rules = [
    {
      description      = "All egress IPv4"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      description      = "All egress IPv6"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

Passos
- terraform init -backend=false
- terraform validate
- terraform plan -var 'vpc_id=vpc-0123456789abcdef0'
- terraform apply -var 'vpc_id=vpc-0123456789abcdef0'

Variaveis principais
- aws_region (string): Regiao AWS. Padrao: us-east-1
- vpc_id (string): ID da VPC alvo. Obrigatorio.
- name (string): Nome fixo do SG. Se null, usa name_prefix.
- name_prefix (string): Prefixo do nome quando name for null. Padrao: tf-sg-
- description (string): Descricao do SG.
- tags (map(string)): Tags adicionais.
- ingress_rules (lista de objetos): Regras de entrada. Ver detalhes em variables.tf.
- egress_rules (lista de objetos): Regras de saida. Ver detalhes em variables.tf.

Pontos de seguranca
- Saida (egress) bloqueada por padrao. Adicione somente o necessario.
- Evite CIDRs amplos como 0.0.0.0/0 ou ::/0, especialmente em portas administrativas.
- Prefira referenciar SGs ao inves de CIDRs quando possivel.

Outputs
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- ingress_rule_ids
- egress_rule_ids

Limitacoes
- Regras por Security Group de origem/destino exigem que os SGs estejam na mesma VPC.
- Quando ip_protocol = "-1" (todos), os campos de porta sao ignorados pelo provider e definidos como null automaticamente na implementacao deste modulo.
