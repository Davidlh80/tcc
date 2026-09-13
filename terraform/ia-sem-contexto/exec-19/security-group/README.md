# Security Group Blueprint

Blueprint Terraform para provisionamento de um Security Group na AWS, dentro de uma VPC existente informada via variavel.

## Recursos criados

- `aws_security_group.this`

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "web-security-group"

  ingress_rules = [
    {
      description = "Allow HTTPS from corporate network"
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

## Inputs

| Nome          | Descricao                                              | Tipo           | Default                                    |
|---------------|----------------------------------------------------------|----------------|---------------------------------------------|
| aws_region    | Regiao AWS onde os recursos serao provisionados         | string         | "us-east-1"                                 |
| vpc_id        | ID da VPC onde o Security Group sera criado (obrigatorio)| string         | -                                            |
| name          | Nome do Security Group                                   | string         | "app-security-group"                        |
| description   | Descricao do Security Group                              | string         | "Managed by Terraform"                      |
| ingress_rules | Lista de regras de entrada                                | list(object)   | []                                           |
| egress_rules  | Lista de regras de saida                                  | list(object)   | allow all outbound (0.0.0.0/0)               |
| tags          | Tags adicionais aplicadas ao Security Group               | map(string)    | {}                                           |

## Outputs

| Nome                     | Descricao                                      |
|--------------------------|--------------------------------------------------|
| security_group_id        | ID do Security Group criado                     |
| security_group_arn       | ARN do Security Group criado                     |
| security_group_name      | Nome do Security Group criado                    |
| security_group_vpc_id    | ID da VPC associada ao Security Group             |
| security_group_owner_id  | ID da conta AWS proprietaria do Security Group    |

## Consideracoes de seguranca

- Nenhuma regra de entrada e criada por padrao (`ingress_rules = []`), evitando exposicao acidental de portas.
- Ao definir regras de entrada, prefira CIDRs restritos em vez de `0.0.0.0/0`, especialmente para portas administrativas (ex.: 22, 3389).
- A regra de saida padrao libera todo o trafego de saida; restrinja `egress_rules` conforme a necessidade do workload.
- Nenhum valor sensivel ou credencial esta fixado no codigo.
