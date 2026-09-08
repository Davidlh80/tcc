Nome
- Blueprint Terraform para criar um Security Group na AWS.

Descricao
- Este template cria um Security Group em uma VPC informada, com regras de ingress/egress configuraveis via variaveis.
- Seguranca por padrao: nenhuma regra de entrada e uma regra de saida liberando todo trafego (personalizavel).

Arquivos
- versions.tf: Versoes do Terraform e provider AWS.
- variables.tf: Variaveis de configuracao.
- main.tf: Provider AWS e recurso aws_security_group com regras dinamicas.
- outputs.tf: Informacoes relevantes do Security Group criado.
- README.md: Instrucoes de uso.

Requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS devem estar configuradas no ambiente de execucao (nao definidas neste template).
- Uma VPC valida ja existente para associar o Security Group.

Variaveis principais
- region (string): Regiao AWS. Padrao: us-east-1
- vpc_id (string): ID da VPC de destino. Obrigatorio.
- name (string): Nome do Security Group. Padrao: secure-sg
- description (string): Descricao do Security Group. Padrao: Security Group gerenciado por Terraform
- tags (map(string)): Tags adicionais. Padrao: {}
- ingress_rules (list(object)): Regras de entrada. Padrao: []
- egress_rules (list(object)): Regras de saida. Padrao: permite todo trafego de saida para IPv4 e IPv6

Formato das regras (ingress_rules e egress_rules)
- Cada item do atributo é um objeto com campos:
  - description (string, opcional)
  - protocol (string, ex: tcp, udp, icmp, -1 para todos)
  - from_port (number)
  - to_port (number)
  - cidr_blocks (list(string), opcional)
  - ipv6_cidr_blocks (list(string), opcional)
  - prefix_list_ids (list(string), opcional)
  - source_security_group_id (string, opcional)
- Pelo menos um dos seguintes deve ser definido em cada regra: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids ou source_security_group_id.

Exemplos de uso
- Definindo apenas a VPC (sem ingress; egress padrao liberado):
  vpc_id = "vpc-0123456789abcdef0"

- Exemplo com regras de ingress para HTTP/HTTPS a partir da Internet e SSH restrito a um CIDR especifico:
  vpc_id = "vpc-0123456789abcdef0"
  name   = "web-sg"
  ingress_rules = [
    {
      description  = "HTTP from Internet"
      protocol     = "tcp"
      from_port    = 80
      to_port      = 80
      cidr_blocks  = ["0.0.0.0/0"]
    },
    {
      description      = "HTTPS from Internet (IPv6)"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description  = "SSH from corp"
      protocol     = "tcp"
      from_port    = 22
      to_port      = 22
      cidr_blocks  = ["203.0.113.0/24"]
    }
  ]

- Exemplo de regra de egress restrita somente a HTTP/HTTPS:
  egress_rules = [
    {
      description = "Allow outbound HTTP"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description      = "Allow outbound HTTPS"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

Como executar
- terraform init -backend=false
- terraform validate
- terraform plan -var="vpc_id=vpc-0123456789abcdef0"
- terraform apply -var="vpc_id=vpc-0123456789abcdef0"

Boas praticas
- Restrinja ingress ao minimo necessario usando cidr_blocks especificos ao inves de 0.0.0.0/0 ou ::/0.
- Avalie restringir egress conforme o principio do menor privilegio.
- Utilize tags para facilitar governanca e cobranca (cost allocation).
