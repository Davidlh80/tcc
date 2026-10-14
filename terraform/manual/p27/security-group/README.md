Template Terraform — AWS Security Group
Objetivo
Criar um Security Group associado a uma VPC, com regras de entrada e saída explícitas e tags de governança.

Estrutura
versions.tf: versões do Terraform e provider AWS.
main.tf: Security Group e regras de rede.
variables.tf: parâmetros e validações.
outputs.tf: identificadores do Security Group.
README.md: documentação de utilização.
Pré-requisitos
Terraform >= 1.5.0.
Provider AWS configurado.
Uma VPC existente.
Permissões para criar Security Groups e regras de rede.
Variáveis
Variável	Tipo	Obrigatória	Descrição
security_group_name	string	Sim	Nome-base
vpc_id	string	Sim	ID da VPC
environment	string	Sim	dev, hml, stg ou prod
description	string	Não	Finalidade do recurso
ingress_rules	list(object)	Não	Regras de entrada
egress_rules	list(object)	Não	Regras de saída
additional_tags	map(string)	Não	Tags adicionais
Cada regra possui name, description, protocol, from_port, to_port e cidr_ipv4.

Exemplo de configuração
Crie terraform.tfvars:

security_group_name = "app-web"
vpc_id              = "vpc-0123456789abcdef0"
environment         = "dev"
description         = "Acesso HTTPS para aplicacao web"

ingress_rules = [
  {
    name        = "https-corporate"
    description = "HTTPS da rede corporativa"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_ipv4   = "10.20.0.0/16"
  }
]

egress_rules = [
  {
    name        = "https-private-services"
    description = "HTTPS para servicos privados"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_ipv4   = "10.30.0.0/16"
  }
]

additional_tags = {
  Project = "AplicacaoWeb"
  Owner   = "Plataforma"
}
Os CIDRs são exemplos. Substitua-os pelas redes autorizadas.

Outputs
security_group_id
security_group_arn
security_group_name
Execução
terraform init -backend=false
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
Análise automatizada
checkov -d . --framework terraform
trivy config .
Revise todos os achados e justifique eventuais exceções.

Segurança
As listas de regras são vazias por padrão.
Não são criadas regras explícitas com 0.0.0.0/0.
As regras usam CIDRs IPv4.
As tags obrigatórias não podem ser sobrescritas por tags adicionais.
A configuração não habilita IPv6; adicione suporte específico se necessário.
O Security Group não concede acesso a recursos por si só: as regras devem refletir os fluxos necessários à aplicação.
Avalie dependências como DNS, endpoints privados, APIs e atualizações antes de restringir a saída em produção.
Observações
O Security Group tem comportamento de firewall stateful. O tráfego de resposta a conexões permitidas é tratado pelo estado da conexão, sem exigir uma regra inversa correspondente.
