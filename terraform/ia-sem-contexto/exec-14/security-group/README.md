# Security Group (AWS)

Blueprint Terraform para provisionar um Security Group na AWS dentro de uma VPC existente, informada via variavel.

## Recursos criados

- `aws_security_group.this`: Security Group com regras de entrada e saida configuraveis dinamicamente.

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "app-sg"
  description = "Security Group da aplicacao"

  ingress_rules = [
    {
      description = "Permite HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Permite todo o trafego de saida"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Variaveis

| Nome           | Descricao                                             | Tipo           | Padrao                                    |
|----------------|--------------------------------------------------------|----------------|--------------------------------------------|
| aws_region     | Regiao AWS onde os recursos serao criados               | string         | `us-east-1`                                |
| vpc_id         | ID da VPC onde o Security Group sera criado             | string         | -                                           |
| name           | Nome do Security Group                                  | string         | `sg-default`                                |
| description    | Descricao do Security Group                             | string         | `Security Group gerenciado via Terraform`   |
| ingress_rules  | Lista de regras de entrada                              | list(object)   | `[]`                                        |
| egress_rules   | Lista de regras de saida                                | list(object)   | Permite todo o trafego de saida             |
| tags           | Tags adicionais aplicadas ao recurso                     | map(string)    | `{}`                                        |

## Outputs

| Nome                 | Descricao                                  |
|----------------------|---------------------------------------------|
| security_group_id    | ID do Security Group criado                 |
| security_group_arn   | ARN do Security Group criado                |
| security_group_name  | Nome do Security Group criado               |
| vpc_id               | ID da VPC associada ao Security Group        |

## Observacoes de seguranca

- Nenhuma regra de entrada e criada por padrao; e responsabilidade de quem consome este blueprint definir `ingress_rules` com o menor escopo possivel de portas e CIDRs.
- Evite usar `0.0.0.0/0` em regras de entrada, exceto quando estritamente necessario (ex.: servicos publicos como HTTP/HTTPS).
- O `lifecycle.create_before_destroy` esta habilitado para evitar interrupcoes ao substituir o Security Group.
