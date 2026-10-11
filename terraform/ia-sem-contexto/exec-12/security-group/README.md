# Security Group - Blueprint Terraform

Blueprint Terraform para provisionamento de um Security Group na AWS, com regras de entrada e saida explicitas, tags configuraveis e outputs relevantes.

## Recursos criados

- `aws_security_group.this`: Security Group associado a uma VPC configurada via variavel.

## Pre-requisitos

- Terraform >= 1.5.0
- Provider AWS (`hashicorp/aws`) `~> 5.0`
- Uma VPC existente (ID informado via variavel `vpc_id`), criada pelo ambiente onde este blueprint sera aplicado.

## Variaveis principais

| Nome            | Descricao                                                          | Tipo                 | Default                  |
|-----------------|---------------------------------------------------------------------|----------------------|---------------------------|
| `vpc_id`        | ID da VPC onde o Security Group sera criado (obrigatorio)          | `string`              | sem default               |
| `name`          | Nome do Security Group                                             | `string`              | `"sg-blueprint"`          |
| `description`   | Descricao do Security Group                                        | `string`              | `"Security Group gerenciado via Terraform"` |
| `ingress_rules` | Lista de regras de entrada explicitas                              | `list(object({...}))`| regra HTTPS interna       |
| `egress_rules`  | Lista de regras de saida explicitas                                | `list(object({...}))`| HTTPS e DNS de saida       |
| `tags`          | Tags adicionais aplicadas ao recurso                                | `map(string)`         | `{}`                      |

As regras padrao de `ingress_rules` e `egress_rules` sao apenas exemplos conservadores. Ajuste os valores de acordo com o trafego real exigido pela aplicacao, evitando CIDRs amplos (`0.0.0.0/0`) sempre que possivel.

## Outputs

- `security_group_id`: ID do Security Group criado.
- `security_group_arn`: ARN do Security Group criado.
- `security_group_name`: Nome do Security Group criado.
- `security_group_vpc_id`: ID da VPC associada.
- `ingress_rules`: Regras de entrada aplicadas.
- `egress_rules`: Regras de saida aplicadas.

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-xxxxxxxx"
  name   = "sg-app"

  ingress_rules = [
    {
      description = "Permite HTTPS de uma rede especifica"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["203.0.113.0/24"]
    }
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Validacao local

Este blueprint nao utiliza backend remoto e pode ser validado localmente sem credenciais reais:

```
terraform init -backend=false
terraform validate
```

## Boas praticas aplicadas

- Nenhuma regra de entrada ou saida liberada para todas as portas/protocolos por padrao.
- Uso de `dynamic` blocks para permitir regras configuraveis sem duplicar codigo.
- ID da VPC obrigatorio via variavel, sem dependencia da VPC default da conta.
- Tags aplicadas de forma consistente, combinando nome padrao com tags customizadas.
