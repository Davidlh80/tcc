# Security Group (AWS)

Blueprint Terraform para provisionar um Security Group na AWS dentro de uma VPC existente, com regras de entrada e saida totalmente configuraveis por variavel.

## Caracteristicas

- Nenhuma regra de entrada por padrao (deny-all inbound).
- Regra de saida padrao permitindo todo o trafego de saida (all-outbound), podendo ser sobrescrita.
- ID da VPC configuravel via variavel `vpc_id`.
- Regras de entrada e saida definidas como listas de objetos, permitindo multiplas regras.
- Validacoes de entrada para portas, protocolos e formato de CIDRs.
- Tags customizaveis via variavel `tags`.

## Uso

```
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "app-sg"
  description = "Security Group para a aplicacao"

  ingress_rules = [
    {
      description = "Acesso HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "exemplo"
  }
}
```

## Inputs

| Nome            | Descricao                                      | Tipo              | Default                          |
|-----------------|-------------------------------------------------|-------------------|-----------------------------------|
| vpc_id          | ID da VPC onde o Security Group sera criado     | string            | -                                  |
| name            | Nome do Security Group                          | string            | -                                  |
| description     | Descricao do Security Group                     | string            | "Managed by Terraform"            |
| ingress_rules   | Lista de regras de entrada                      | list(object(...)) | []                                 |
| egress_rules    | Lista de regras de saida                        | list(object(...)) | allow-all outbound (0.0.0.0/0)    |
| tags            | Tags adicionais                                 | map(string)       | {}                                 |

## Outputs

| Nome                  | Descricao                                   |
|-----------------------|-----------------------------------------------|
| security_group_id     | ID do Security Group criado                   |
| security_group_arn    | ARN do Security Group criado                  |
| security_group_name   | Nome do Security Group criado                 |
| vpc_id                | ID da VPC associada ao Security Group         |
| owner_id              | ID da conta AWS proprietaria do Security Group|

## Validacao

Este modulo pode ser validado sem credenciais reais e sem backend remoto:

```
terraform init -backend=false
terraform validate
```
