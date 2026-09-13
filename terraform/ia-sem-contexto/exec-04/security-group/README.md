# Security Group

Blueprint Terraform para provisionar um Security Group na AWS dentro de uma VPC ja existente (por exemplo, uma VPC criada pelo proprio ambiente de teste), sem depender da VPC padrao da conta.

## Recursos criados

- `aws_security_group.this`

## Requisitos

- Terraform >= 1.5.0
- Provider AWS `~> 5.0`
- Uma VPC ja existente, cujo ID sera informado via variavel `vpc_id`.

## Padroes de seguranca adotados

- Nenhuma regra de entrada e liberada por padrao (`ingress_rules` comeca como lista vazia). Cada regra deve ser declarada explicitamente pelo consumidor do modulo.
- A unica regra padrao e a de saida total (`0.0.0.0/0`), comportamento usual em ambientes AWS, mas totalmente sobrescrevivel via `egress_rules`.
- Validacoes de variaveis garantem que `vpc_id` tenha o formato esperado (`vpc-xxxxxxxx`) e que todos os CIDRs informados em `ingress_rules` e `egress_rules` sejam blocos CIDR validos.
- Nenhum valor sensivel ou credencial esta hardcoded; toda configuracao e feita via variaveis.

## Uso

```
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "app-sg"
  description = "Security Group da aplicacao"

  ingress_rules = [
    {
      description = "HTTPS de clientes internos"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "test"
  }
}
```

## Inputs

| Nome            | Descricao                                              | Tipo         | Default                              |
|-----------------|---------------------------------------------------------|--------------|---------------------------------------|
| region          | Regiao AWS                                               | string       | "us-east-1"                          |
| vpc_id          | ID da VPC onde o Security Group sera criado              | string       | (obrigatorio)                        |
| name            | Nome do Security Group                                   | string       | "example-sg"                         |
| description     | Descricao do Security Group                              | string       | "Managed by Terraform"               |
| ingress_rules   | Lista de regras de entrada                               | list(object) | []                                   |
| egress_rules    | Lista de regras de saida                                 | list(object) | Permite todo o trafego de saida       |
| tags            | Tags adicionais                                          | map(string)  | {}                                   |

## Outputs

| Nome                    | Descricao                              |
|-------------------------|------------------------------------------|
| security_group_id       | ID do Security Group criado              |
| security_group_arn      | ARN do Security Group criado             |
| security_group_name     | Nome do Security Group criado            |
| security_group_vpc_id   | ID da VPC associada ao Security Group    |

## Validacao

```
terraform init -backend=false
terraform validate
```
