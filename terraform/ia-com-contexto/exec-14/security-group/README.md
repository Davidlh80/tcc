1. Visão geral do recurso
Este template provisiona um Security Group na AWS seguindo o padrão organizacional:
- Nome no padrão <ambiente>-<sistema>-sg-<finalidade>;
- Tags obrigatórias aplicadas automaticamente;
- Regras de segurança rígidas:
  - Proíbe 0.0.0.0/0 e ::/0 em qualquer porta diferente de 443/tcp (ingress e egress);
  - Exige descrição em toda regra de entrada e saída;
  - Egress explicitamente declarado e fechado por padrão (lista vazia).

2. Tabela de variáveis
- region (string, obrigatório): Região AWS onde o recurso será criado. Ex.: us-east-1.
- environment (string, obrigatório): Ambiente de implantação. Valores permitidos: dev, hml, prd.
- system (string, obrigatório): Nome do sistema (minúsculas, números e hífens).
- security_group_name (string, obrigatório): Nome completo do Security Group no padrão <environment>-<system>-sg-<purpose>. Validado contra environment e system fornecidos.
- vpc_id (string, obrigatório): ID da VPC onde o SG será criado. Ex.: vpc-xxxxxxxx.
- security_group_description (string, obrigatório): Descrição do Security Group (mínimo 10 caracteres).
- security_group_ingress_rules (list(object), opcional, padrão []): Regras de entrada. Cada objeto aceita:
  - description (string, obrigatório)
  - protocol (string, obrigatório) — ex.: tcp, udp, icmp, -1
  - from_port (number, obrigatório)
  - to_port (number, obrigatório)
  - cidr_blocks (list(string), opcional, padrão [])
  - ipv6_cidr_blocks (list(string), opcional, padrão [])
  - security_groups (list(string), opcional, padrão [])
  - self (bool, opcional, padrão false)
  Restrições: descrição obrigatória; to_port >= from_port; não permitir 0.0.0.0/0 ou ::/0 exceto exatamente tcp/443.
- security_group_egress_rules (list(object), opcional, padrão []): Regras de saída. Mesmo formato e validações das regras de entrada. Padrão é lista vazia (nenhuma saída permitida).
- additional_tags (map(string), opcional, padrão {}): Tags adicionais mescladas às tags obrigatórias.

3. Tabela de outputs
- security_group_name: Nome do Security Group criado.
- security_group_arn: ARN do Security Group criado.
- security_group_id: ID do Security Group criado.

4. Exemplo de uso do módulo/recurso
module "sg_example" {
  source = "."

  region                     = "us-east-1"
  environment                = "dev"
  system                     = "tcc"
  vpc_id                     = "vpc-0123456789abcdef0"
  security_group_name        = "dev-tcc-sg-web"
  security_group_description = "Security Group para workload web com controle estrito de egress."

  security_group_ingress_rules = [
    {
      description       = "Permitir HTTPS público"
      protocol          = "tcp"
      from_port         = 443
      to_port           = 443
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      security_groups   = []
      self              = false
    },
    {
      description       = "Permitir SSH de bastion"
      protocol          = "tcp"
      from_port         = 22
      to_port           = 22
      cidr_blocks       = ["10.0.0.0/16"]
      ipv6_cidr_blocks  = []
      security_groups   = []
      self              = false
    }
  ]

  security_group_egress_rules = [
    {
      description       = "Permitir saída HTTPS para Internet"
      protocol          = "tcp"
      from_port         = 443
      to_port           = 443
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      security_groups   = []
      self              = false
    }
  ]

  additional_tags = {
    Application = "webapp"
    OwnerEmail  = "devops@example.org"
  }
}
