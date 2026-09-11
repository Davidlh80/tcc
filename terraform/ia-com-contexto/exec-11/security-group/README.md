Visão geral do recurso
Este template provisiona um Security Group na AWS seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-sg-<security_group_name>
- Tags obrigatórias aplicadas a todos os recursos que suportam tags
- Regras de segurança:
  - Proibido 0.0.0.0/0 (e ::/0) em qualquer porta além de 443/tcp;
  - Descrição obrigatória em todas as regras de entrada e saída;
  - Egress explicitamente declarado, sem liberação irrestrita por padrão (nenhuma regra criada se não configurado);
  - Regras de entrada e saída totalmente configuráveis via variáveis.

Tabela de variáveis
- environment (string) [obrigatória]: Ambiente alvo (dev, hml, prd).
- system (string) [obrigatória]: Nome curto do sistema/produto (ex.: tcc).
- region (string) [obrigatória]: Região AWS onde os recursos serão provisionados (ex.: us-east-1).
- additional_tags (map(string)) [opcional]: Tags adicionais a serem mescladas às tags padrão.
- security_group_name (string) [obrigatória]: Finalidade ou nome lógico do Security Group (usado na composição do nome).
- security_group_description (string) [opcional]: Descrição do Security Group. Padrão: "Managed by Terraform".
- vpc_id (string) [obrigatória]: ID da VPC alvo (ex.: vpc-xxxxxxxx).
- ingress_rules (list(object)) [opcional]: Lista de regras de entrada. Campos do objeto:
  - description (string) obrigatório
  - protocol (string) obrigatório (ex.: tcp, udp, icmp, -1)
  - from_port (number) obrigatório
  - to_port (number) obrigatório
  - Uma e somente uma origem entre:
    - cidr_ipv4 (string)
    - cidr_ipv6 (string)
    - prefix_list_id (string)
    - referenced_security_group_id (string)
    - self (bool) = true
  Restrições adicionais: descrição obrigatória; from_port <= to_port; se origem for 0.0.0.0/0 ou ::/0, somente tcp/443 é permitido.
- egress_rules (list(object)) [opcional]: Lista de regras de saída. Campos do objeto:
  - description (string) obrigatório
  - protocol (string) obrigatório
  - from_port (number) obrigatório
  - to_port (number) obrigatório
  - Um e somente um destino entre:
    - cidr_ipv4 (string)
    - cidr_ipv6 (string)
    - prefix_list_id (string)
    - referenced_security_group_id (string)
    - self (bool) = true
  Restrições adicionais: descrição obrigatória; from_port <= to_port; se destino for 0.0.0.0/0 ou ::/0, somente tcp/443 é permitido.

Tabela de outputs
- security_group_name: Nome do Security Group.
- security_group_arn: ARN do Security Group.
- security_group_id: ID do Security Group.

Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "./"

  region              = "us-east-1"
  environment         = "dev"
  system              = "tcc"
  security_group_name = "web"
  vpc_id              = "vpc-0123456789abcdef0"

  additional_tags = {
    Application = "portal-web"
  }

  # Permite somente HTTPS de qualquer origem (conforme política)
  ingress_rules = [
    {
      description = "Allow HTTPS from Internet"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = "0.0.0.0/0"
    }
  ]

  # Egress explícito: HTTPS para a Internet (sem liberação irrestrita)
  egress_rules = [
    {
      description = "Egress HTTPS to Internet"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = "0.0.0.0/0"
    }
  ]
}
