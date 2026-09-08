Blueprint Terraform — AWS Security Group

Resumo
- Este template cria um Security Group em uma VPC informada.
- Sem ingress por padrao (lista vazia). Egress liberado por padrao para todo destino (IPv4 e IPv6).
- Todos os valores sensiveis ou variaveis de ambiente devem ser fornecidos externamente (sem backends remotos).

Arquivos
- main.tf: definicao do provider e do recurso aws_security_group.
- variables.tf: variaveis de configuracao com validacoes.
- outputs.tf: informacoes exportadas apos a criacao.
- versions.tf: versoes minimas do Terraform e do provider AWS.

Como usar
1) Ajuste variaveis conforme necessario (ver Secao Variaveis).
2) Execute:
   terraform init -backend=false
   terraform validate
   terraform plan -var="vpc_id=vpc-xxxxxxxx"
   terraform apply -var="vpc_id=vpc-xxxxxxxx"

Exemplo simples
- Criar um SG sem regras de entrada (default) e egress liberado (default):
  terraform apply -var="vpc_id=vpc-0123456789abcdef0"

Exemplo com regras customizadas
- Abrir SSH (22/tcp) para um bloco especifico e HTTP (80/tcp) para todos:
  terraform apply \
    -var="vpc_id=vpc-0123456789abcdef0" \
    -var='ingress_rules=[
      {
        description      = "SSH from Corp"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["203.0.113.0/24"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
      },
      {
        description      = "HTTP from anywhere"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids  = []
        security_groups  = []
        self             = false
      }
    ]'

Decisoes de seguranca padrao
- Nao cria regras de entrada por padrao.
- Egress liberado por padrao (comum em AWS). Ajuste egress_rules para endurecer a postura.
- revoke_rules_on_delete=true para ajudar na remocao limpa do SG.

Variaveis principais
- region (string): Regiao AWS. Padrao: us-east-1.
- vpc_id (string, obrigatoria): VPC onde o SG sera criado. Formato vpc-xxxxxxxx.
- sg_name (string): Nome do SG. Padrao: example-sg.
- description (string): Descricao do SG. Padrao: Security Group gerenciado por Terraform.
- revoke_rules_on_delete (bool): Revoga regras antes de deletar. Padrao: true.
- enable_name_tag (bool): Adiciona tag Name com o valor de sg_name. Padrao: true.
- tags (map(string)): Tags adicionais. Padrao: {}.
- ingress_rules (list(object)): Regras de entrada. Padrao: [].
- egress_rules (list(object)): Regras de saida. Padrao: permite todo trafego de saida.

Estrutura das regras (ingress_rules e egress_rules)
- description (string)
- from_port (number)
- to_port (number)
- protocol (string): tcp, udp, icmp, icmpv6 ou -1 (any)
- cidr_blocks (list(string))
- ipv6_cidr_blocks (list(string))
- prefix_list_ids (list(string))
- security_groups (list(string))
- self (bool)

Outputs
- security_group_id
- security_group_arn
- security_group_name
- security_group_vpc_id
- security_group_tags
- ingress_rules_applied
- egress_rules_applied

Notas
- Este template nao configura backend remoto.
- Compatibilidade testada com: terraform fmt, terraform init -backend=false, terraform validate.
- Nenhuma credencial real eh necessaria para validacao sintatica; a aplicacao exige credenciais AWS validas.
