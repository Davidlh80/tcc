# Security Group (AWS) — Blueprint Terraform

Blueprint para provisionamento de um Security Group na AWS, associado a uma VPC existente informada por variavel.

## Recursos criados

- `aws_security_group.this`

## Requisitos

- Terraform >= 1.5.0
- Provider AWS >= 5.0
- Uma VPC ja existente (o `vpc_id` deve ser fornecido pelo consumidor do modulo)

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "sg-app"
  description = "Security Group da aplicacao"

  ingress_rules = [
    {
      description = "Permite HTTPS a partir da rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "test"
    Owner       = "team-x"
  }
}
```

## Variaveis

| Nome            | Descricao                                              | Tipo           | Default                                   |
|-----------------|---------------------------------------------------------|----------------|---------------------------------------------|
| aws_region      | Regiao AWS onde os recursos serao provisionados          | `string`       | `"us-east-1"`                                |
| vpc_id          | ID da VPC onde o Security Group sera criado              | `string`       | (obrigatorio)                                |
| name            | Nome do Security Group                                    | `string`       | `"sg-default"`                               |
| description     | Descricao do Security Group                               | `string`       | `"Security Group gerenciado via Terraform."` |
| ingress_rules   | Lista de regras de entrada (portas, protocolo, CIDRs)      | `list(object)` | `[]`                                         |
| egress_rules    | Lista de regras de saida (portas, protocolo, CIDRs)         | `list(object)` | Permite todo o trafego de saida (`0.0.0.0/0`) |
| tags            | Tags adicionais aplicadas ao recurso                       | `map(string)`  | `{}`                                         |

## Outputs

| Nome                 | Descricao                                |
|----------------------|--------------------------------------------|
| security_group_id    | ID do Security Group criado                 |
| security_group_arn   | ARN do Security Group criado                |
| security_group_name  | Nome do Security Group criado               |
| vpc_id               | ID da VPC associada ao Security Group       |

## Seguranca

- Nenhuma regra de entrada e criada por padrao (`ingress_rules = []`); o consumidor deve declarar explicitamente as portas e origens necessarias, evitando exposicao acidental de servicos.
- A regra de saida padrao permite todo o trafego (`0.0.0.0/0`), comportamento padrao do modelo de seguranca da AWS para Security Groups; ajuste `egress_rules` caso um controle mais restritivo seja necessario.
- Todas as entradas de `cidr_blocks` sao validadas como blocos CIDR validos antes da aplicacao.
- Evite usar `0.0.0.0/0` em `ingress_rules` para portas sensiveis (ex.: 22, 3389) em ambientes de producao.

## Validacao

```bash
terraform init -backend=false
terraform validate
```
