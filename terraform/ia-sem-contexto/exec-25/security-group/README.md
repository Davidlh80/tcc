Blueprint Terraform: AWS Security Group

Descricao
- Provisiona um Security Group em uma VPC especifica.
- Sem regras por padrao (deny-all ingress e deny-all egress) para postura segura.
- Regras de ingress/egress configuraveis por variaveis.
- Tags padrao incluem ManagedBy=Terraform e Name=<name>.

Arquivos
- versions.tf: Versoes de Terraform e provider.
- variables.tf: Variaveis de configuracao com validacoes.
- main.tf: Provider AWS e recurso aws_security_group com regras dinamicas.
- outputs.tf: IDs e metadados do Security Group.
- README.md: Instrucoes de uso.

Variaveis principais
- region (string): Regiao AWS. Default: us-east-1.
- vpc_id (string): ID da VPC onde o SG sera criado. Ex: vpc-0123abcd4567efgh.
- name (string): Nome do Security Group. Default: secure-sg.
- description (string): Descricao do SG. Default: Security Group managed by Terraform.
- revoke_rules_on_delete (bool): Revogar regras antes de deletar o SG. Default: true.
- ingress_rules (list(object)): Lista de regras de entrada.
- egress_rules (list(object)): Lista de regras de saida.
- tags (map(string)): Tags adicionais.

Formato das regras (ingress_rules/egress_rules)
Cada regra aceita:
- description (string, opcional): Texto livre.
- from_port (number): Porta inicial (0..65535 ou -1).
- to_port (number): Porta final (0..65535 ou -1).
- protocol (string): -1, tcp, udp, icmp, icmpv6.
- cidr_blocks (list(string), opcional): CIDRs IPv4.
- ipv6_cidr_blocks (list(string), opcional): CIDRs IPv6.
- security_group_ids (list(string), opcional): IDs de SG como origem/destino.
- self (bool, opcional): true para referenciar o proprio SG.

Exemplo de uso (minimo)
- Defina as variaveis necessarias, por exemplo via terraform.tfvars:

vpc_id = "vpc-0123abcd4567efgh"

- Aplicar:
terraform init -backend=false
terraform validate
terraform plan
terraform apply

Exemplo com regras
- Permitir SSH (22/tcp) a partir de um CIDR especifico.
- Permitir saida total (0-65535, -1):
 
region  = "us-east-1"
vpc_id  = "vpc-0123abcd4567efgh"
name    = "example-sg"
ingress_rules = [
  {
    description        = "SSH from office"
    from_port          = 22
    to_port            = 22
    protocol           = "tcp"
    cidr_blocks        = ["203.0.113.0/24"]
    ipv6_cidr_blocks   = []
    security_group_ids = []
    self               = false
  }
]
egress_rules = [
  {
    description        = "Allow all egress"
    from_port          = 0
    to_port            = 0
    protocol           = "-1"
    cidr_blocks        = ["0.0.0.0/0"]
    ipv6_cidr_blocks   = ["::/0"]
    security_group_ids = []
    self               = false
  }
]

Boas praticas
- Restrinja CIDRs ao minimo necessario.
- Prefira IPv6 apenas quando requerido e com filtros adequados.
- Evite abrir portas amplas (0-65535) e protocolos -1 sem justificativa.
- Utilize tags para identificacao e governanca.

Saidas
- security_group_id: ID do SG.
- security_group_arn: ARN do SG.
- security_group_name: Nome efetivo.
- security_group_vpc_id: VPC associada.
- security_group_tags: Tags finais aplicadas.

Notas
- Este template nao configura backend remoto e nao depende de credenciais para validacao sintatica.
- Para execucao real, configure suas credenciais AWS de forma segura (perfil, variaveis de ambiente, etc).
