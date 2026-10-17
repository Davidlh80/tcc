# Security Groups por camada

## 1. Visão geral do recurso

O módulo cria três security groups separados, um para cada finalidade, seguindo
o padrão `<ambiente>-<sistema>-sg-<finalidade>`. O security group do backend permite HTTP somente dos CIDRs explicitamente
configurados (nenhum por padrão), HTTPS dos CIDRs configurados e SSH apenas dos
CIDRs `/32` informados. O banco e o Redis aceitam somente tráfego da camada backend, por
referência de security group. O egress do backend é limitado a HTTPS e às portas
do banco e do Redis; os security groups de banco e cache não recebem regras de
egress. Por padrão, o módulo também gerencia o security group default da VPC
para remover suas regras.

Diagrama da arquitetura:

```text
Internet → backend-sg → rds-sg → redis-sg
```

A comunicação de banco e cache é permitida exclusivamente do `backend-sg`;
`rds-sg` não tem regra para iniciar tráfego em `redis-sg`.

Para migração sem downtime, anexe o novo security group às interfaces ou
instâncias, valide a aplicação e só então remova o security group antigo.
`create_before_destroy` é configurado nos três security groups nomeados. Seus
nomes usam `name_prefix` com o padrão organizacional seguido de um sufixo
gerado, permitindo criar o novo grupo antes de destruir o antigo.

## 2. Tabela de variáveis (nome, tipo, obrigatória, descrição)

| Nome | Tipo | Obrigatória | Descrição |
|---|---|---|---|
| `environment` | `string` | Sim | Ambiente, limitado a `dev`, `hml` ou `prd`. |
| `system` | `string` | Sim | Identificador do sistema usado nos nomes dos security groups. |
| `region` | `string` | Sim | Região AWS usada pelo provider. |
| `additional_tags` | `map(string)` | Não | Tags adicionais opcionais; padrão `{}`. Tags obrigatórias não podem ser sobrescritas. |
| `security_group_purposes` | `object({ backend = string, rds = string, redis = string })` | Sim | Finalidades padronizadas que formam os nomes dos três security groups. |
| `vpc_id` | `string` | Sim | ID da VPC; deve corresponder ao formato AWS `vpc-` seguido de 8 ou 17 caracteres hexadecimais. |
| `owner` | `string` | Sim | Responsável da tag `Owner`; deve ser `devops`. |
| `required_tags` | `map(string)` | Não | Tags de valor fixo `Project`, `ManagedBy` e `CostCenter`; padrão conforme o contexto organizacional. `Environment` e `Owner` são aplicadas a partir das variáveis correspondentes. |
| `http_ingress_cidrs` | `list(string)` | Não | CIDRs permitidos para HTTP; padrão `[]` e `0.0.0.0/0` não é permitido. |
| `https_ingress_cidrs` | `list(string)` | Não | CIDRs permitidos para HTTPS; padrão `["0.0.0.0/0"]`. |
| `ssh_cidrs` | `list(string)` | Sim | CIDRs IPv4 `/32` permitidos para SSH; sem padrão, lista vazia desativa SSH. |
| `https_egress_cidrs` | `list(string)` | Não | CIDRs permitidos para egress HTTPS; padrão `["0.0.0.0/0"]`. |
| `rds_port` | `number` | Não | Porta TCP do banco, inteiro entre 1 e 65535; padrão `5432`. |
| `redis_port` | `number` | Não | Porta TCP do Redis, inteiro entre 1 e 65535; padrão `6379`. |
| `manage_default_security_group` | `bool` | Não | Gerencia o security group default da VPC sem declarar regras; padrão `true`. |

## 3. Tabela de outputs (nome, descrição)

| Nome | Descrição |
|---|---|
| `security_group_name` | Mapa dos nomes dos security groups, indexado por `backend`, `rds` e `redis`. |
| `security_group_arn` | Mapa dos ARNs dos security groups, indexado por `backend`, `rds` e `redis`. |
| `security_group_id` | Mapa dos IDs dos security groups, indexado por `backend`, `rds` e `redis`. |

## 4. Exemplo de uso do módulo/recurso

```hcl
variable "region" {
  type = string
}

module "security_groups" {
  source = "./terraform/manual/p30/security-group"

  environment = "dev"
  system      = "tcc"
  region      = var.region
  vpc_id      = "vpc-0123456789abcdef0"
  owner       = "devops"

  security_group_purposes = {
    backend = "backend"
    rds     = "rds"
    redis   = "redis"
  }

  ssh_cidrs = ["203.0.113.10/32"]
}
```

## Premissas

- O contexto organizacional não fixa versões de Terraform ou do AWS provider;
  este template usa Terraform `>= 1.5.0` e AWS provider `~> 5.0`, conforme a
  faixa segura indicada na solicitação.
- O owner é uma variável obrigatória, validada contra o valor organizacional
  `devops`; assim, não há default para o responsável e a tag obrigatória
  permanece em conformidade.
- Os nomes seguem o padrão organizacional usando as finalidades
  `backend`, `rds` e `redis` exigidas pela arquitetura. Um sufixo gerado é
  acrescentado para permitir a substituição com `create_before_destroy`.
- O contexto organizacional proíbe `0.0.0.0/0` em portas além de 443/tcp;
  portanto, HTTP (80/tcp) fica fechado por padrão, apesar da configuração
  pública sugerida no pedido. A porta 80 aceita CIDRs restritos via
  `http_ingress_cidrs`.
- `aws_default_security_group` não declara blocos `ingress` ou `egress`;
  habilitá-lo remove as regras gerenciadas do grupo default da VPC.
