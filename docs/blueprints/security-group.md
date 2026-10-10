# Blueprint — AWS Security Group (SG)

## Objetivo

Definir um template Terraform para um Security Group em uma VPC existente, com regras explícitas de entrada e saída e acesso restrito por padrão.

## Estrutura

```text
security-group/
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
└── README.md
```

Em `versions.tf`, declarar a versão compatível do Terraform e o provider `hashicorp/aws`. Configurar a região por variável. Em `main.tf`, criar:

| Recurso Terraform                     | Responsabilidade                              |
| ------------------------------------- | --------------------------------------------- |
| `aws_security_group`                  | Criar o grupo na VPC informada e aplicar tags |
| `aws_vpc_security_group_ingress_rule` | Criar cada regra de entrada configurada       |
| `aws_vpc_security_group_egress_rule`  | Criar cada regra de saída configurada         |

Usar `for_each` com chaves estáveis para as regras. Manter todas as regras em recursos separados, sem misturar regras inline no mesmo grupo. O template não cria VPC nem associa o grupo a instâncias.

## Variáveis

| Nome                  | Tipo          | Obrigatória | Descrição                         |
| --------------------- | ------------- | ----------- | --------------------------------- |
| `environment`         | `string`      | Sim         | Ambiente: `dev`, `hml` ou `prd`   |
| `system`              | `string`      | Sim         | Identificação do sistema          |
| `region`              | `string`      | Sim         | Região AWS do provider            |
| `additional_tags`     | `map(string)` | Não         | Tags adicionais; padrão `{}`      |
| `security_group_name` | `string`      | Sim         | Finalidade usada no nome do grupo |
| `vpc_id`              | `string`      | Sim         | ID da VPC existente               |
| `ingress_rules`       | `map(object)` | Não         | Regras de entrada; padrão `{}`    |
| `egress_rules`        | `map(object)` | Não         | Regras de saída; padrão `{}`      |

Cada objeto de regra contém `description` (`string`), `ip_protocol` (`string`), `from_port` (`number`), `to_port` (`number`) e `cidr_ipv4` (`string`). Neste blueprint, aceitar `tcp` e `udp`, portas de 0 a 65535 e CIDRs IPv4 válidos. Validar `from_port <= to_port` e descrição não vazia.

## Segurança e governança

- Começar sem regras de entrada ou saída; declarar explicitamente as necessárias à aplicação.
- Permitir `0.0.0.0/0` somente quando protocolo, porta inicial e porta final forem `tcp`, `443` e `443`, respectivamente, tanto em entrada quanto em saída.
- Evitar protocolo `-1` e intervalos desnecessariamente amplos.
- Verificar no plano que não permanece saída padrão irrestrita.
- Usar `<ambiente>-<sistema>-sg-<finalidade>` como nome.
- Aplicar `Project = "tcc-iac-ia"`, `Environment = var.environment`, `ManagedBy = "terraform"`, `Owner = "devops"` e `CostCenter = "academic-research"`.
- Mesclar tags adicionais antes das obrigatórias para impedir sua sobrescrita.

## Outputs

| Nome                  | Valor                |
| --------------------- | -------------------- |
| `security_group_name` | Nome do grupo criado |
| `security_group_arn`  | ARN do grupo criado  |
| `security_group_id`   | ID do grupo criado   |

## Exemplo de configuração

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

Substituir a VPC e os CIDRs pelos valores da aplicação.

## Critérios de aceitação

- O grupo usa a VPC informada e todas as regras possuem descrição.
- Não existe saída irrestrita por padrão.
- Regras abertas para qualquer origem ou destino são aceitas somente em `443/tcp`.
- Nomes, tags, variáveis e outputs atendem ao contexto organizacional.
- O README apresenta visão geral, tabela de variáveis, tabela de outputs e exemplo de uso, nessa ordem.
- Executar `terraform fmt -check`, `terraform init -backend=false` e `terraform validate`; executar Checkov e Trivy conforme o fluxo do repositório e revisar os achados.
