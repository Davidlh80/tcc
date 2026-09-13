# Security Group (AWS)

Blueprint Terraform para provisionamento de um Security Group dentro de uma VPC ja existente.

## Descricao

Este modulo cria um `aws_security_group` associado a uma VPC informada via variavel (`vpc_id`). Por padrao, nenhuma regra de entrada (ingress) e permitida, seguindo o principio de seguranca por padrao (secure by default). A saida (egress) permite todo o trafego por padrao, comportamento comum em ambientes de teste, mas totalmente configuravel.

## Requisitos

| Nome | Versao |
|---|---|
| terraform | >= 1.3.0 |
| aws | ~> 5.0 |

## Uso

```
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "sg-web-app"
  description = "Security Group para aplicacao web"

  ingress_rules = [
    {
      description = "Permite HTTPS de rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "dev"
    Owner       = "time-infra"
  }
}
```

## Inputs

| Nome | Descricao | Tipo | Padrao | Obrigatorio |
|---|---|---|---|---|
| vpc_id | ID da VPC onde o Security Group sera criado | string | n/a | sim |
| name | Nome do Security Group | string | "sg-application" | nao |
| description | Descricao do Security Group | string | "Security Group gerenciado via Terraform." | nao |
| ingress_rules | Lista de regras de entrada | list(object) | [] | nao |
| egress_rules | Lista de regras de saida | list(object) | permite todo trafego de saida | nao |
| tags | Tags adicionais | map(string) | {} | nao |
| aws_region | Regiao AWS | string | "us-east-1" | nao |

## Outputs

| Nome | Descricao |
|---|---|
| security_group_id | ID do Security Group criado |
| security_group_arn | ARN do Security Group criado |
| security_group_name | Nome do Security Group criado |
| vpc_id | ID da VPC associada ao Security Group |

## Boas praticas aplicadas

- Nenhuma regra de entrada e liberada por padrao, exigindo definicao explicita pelo consumidor do modulo.
- Uso de `dynamic blocks` para permitir configuracao flexivel de multiplas regras de ingress/egress.
- Validacao do formato de `vpc_id` para evitar erros de configuracao.
- `lifecycle { create_before_destroy = true }` para evitar downtime em atualizacoes de regras.
- Nenhuma credencial ou valor sensivel fixo no codigo.
