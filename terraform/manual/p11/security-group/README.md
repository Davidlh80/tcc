# Blueprint Terraform — security-group

## Visão geral

Cria um Security Group em uma VPC existente, com regras IPv4 TCP/UDP separadas e identificadas por chaves estáveis. Entrada e saída começam vazias. CIDRs /0 são aceitos somente em 443/tcp. O grupo não é associado automaticamente a instâncias.

Requer Terraform >= 1.5 e provider AWS ~> 6.0. Configure as credenciais AWS externamente, pelo perfil ou variáveis de ambiente. Nomes seguem o contexto organizacional e tags obrigatórias prevalecem sobre tags adicionais.

## Variáveis

| Nome | Tipo | Obrigatória | Descrição |
| --- | --- | --- | --- |
| `environment` | `string` | Sim | Ambiente de implantacao. |
| `system` | `string` | Sim | Identificacao do sistema. |
| `region` | `string` | Não | Regiao AWS. |
| `additional_tags` | `map(string)` | Não | Tags adicionais; tags obrigatorias prevalecem. |
| `security_group_name` | `string` | Sim | Finalidade que compoe o nome do grupo. |
| `vpc_id` | `string` | Sim | ID da VPC existente. |
| `ingress_rules` | `map(object)` | Não | Regras explicitas de ingress, com chaves estaveis. |
| `egress_rules` | `map(object)` | Não | Regras explicitas de egress, com chaves estaveis. |

## Outputs

| Nome | Descrição |
| --- | --- |
| `security_group_name` | security_group_name do recurso criado |
| `security_group_arn` | security_group_arn do recurso criado |
| `security_group_id` | security_group_id do recurso criado |

## Exemplo de uso

Na pasta deste blueprint, copie `terraform.tfvars.example` para `terraform.tfvars` e ajuste os identificadores de exemplo:

```hcl
environment         = "dev"
system              = "tcc"
region              = "us-east-1"
security_group_name = "web"
vpc_id              = "vpc-0123456789abcdef0"
additional_tags     = {}

ingress_rules = {
  https_internal = {
    description = "HTTPS da rede interna"
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_ipv4   = "10.0.0.0/24"
  }
}

egress_rules = {
  https_internal = {
    description = "HTTPS para dependencias internas"
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_ipv4   = "10.0.1.0/24"
  }
}
```

Execute:

```sh
terraform fmt -check
terraform init -backend=false
terraform validate
terraform plan -var-file=terraform.tfvars
```

Revise o plano antes de executar `terraform apply -var-file=terraform.tfvars`, que cria recursos na conta configurada. Este blueprint pode ser executado de forma independente na sua própria pasta.

Consulte o [blueprint técnico](../../../docs/blueprints/security-group.md) e o [fluxo de validações](../../../docs/como-executar-validacoes.md) para os critérios de segurança e análise com Checkov e Trivy.
