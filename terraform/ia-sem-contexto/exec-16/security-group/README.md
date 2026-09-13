# Security Group AWS via Terraform

Blueprint Terraform para provisionar um Security Group na AWS dentro de uma VPC existente, com regras de entrada e saida configuraveis via variaveis.

## Recursos criados

- `aws_security_group.this`: Security Group associado a VPC informada em `var.vpc_id`.

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "app-sg"

  ingress_rules = [
    {
      description = "Permite trafego HTTPS de dentro da VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Permite todo trafego de saida"
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

| Nome            | Descricao                                              | Tipo                | Default                                    |
|-----------------|---------------------------------------------------------|---------------------|---------------------------------------------|
| region          | Regiao AWS onde os recursos serao provisionados          | string               | "us-east-1"                                 |
| vpc_id          | ID da VPC onde o Security Group sera criado              | string               | (obrigatorio)                               |
| name            | Nome base do Security Group                              | string               | "app-sg"                                    |
| description     | Descricao do Security Group                              | string               | "Security Group gerenciado via Terraform"   |
| ingress_rules   | Lista de regras de entrada (ingress)                      | list(object)         | Ver `variables.tf`                          |
| egress_rules    | Lista de regras de saida (egress)                         | list(object)         | Ver `variables.tf`                          |
| tags            | Tags adicionais aplicadas ao Security Group               | map(string)          | {}                                          |

## Outputs

| Nome                 | Descricao                                   |
|----------------------|-----------------------------------------------|
| security_group_id    | ID do Security Group criado                   |
| security_group_arn   | ARN do Security Group criado                  |
| security_group_name  | Nome do Security Group criado                 |
| vpc_id               | ID da VPC associada ao Security Group         |

## Consideracoes de seguranca

- Nenhuma regra de entrada e definida por padrao com origem `0.0.0.0/0`; o valor padrao restringe o acesso HTTPS a um bloco CIDR interno de exemplo.
- Ajuste `ingress_rules` e `egress_rules` para refletir apenas o trafego estritamente necessario, evitando exposicao desnecessaria de portas.
- Revise os CIDRs padrao antes de aplicar em ambientes reais, substituindo-os pelos blocos de rede efetivamente utilizados.

## Validacao

```
terraform init -backend=false
terraform validate
```
