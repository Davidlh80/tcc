# Security Group - Blueprint Terraform

Blueprint para provisionamento de um Security Group na AWS, com regras explicitas de entrada e saida, dentro de uma VPC configuravel.

## Recursos criados

- `aws_security_group.this`

## Requisitos

- Terraform >= 1.3.0
- Provider `hashicorp/aws` ~> 5.0

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-xxxxxxxx"
  name   = "app-sg"

  ingress_rules = [
    {
      description = "Permite HTTPS de entrada"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Variaveis de entrada

| Nome          | Descricao                                             | Tipo                 | Default                          |
|---------------|--------------------------------------------------------|----------------------|-----------------------------------|
| region        | Regiao AWS                                              | string               | "us-east-1"                       |
| vpc_id        | ID da VPC onde o Security Group sera criado             | string               | (obrigatorio)                      |
| name          | Nome do Security Group                                  | string               | "app-sg"                           |
| description   | Descricao do Security Group                             | string               | "Security group gerenciado via Terraform" |
| ingress_rules | Lista de regras de entrada explicitas                   | list(object)         | regra HTTPS de rede interna        |
| egress_rules  | Lista de regras de saida explicitas                      | list(object)         | HTTPS e DNS de saida                |
| tags          | Tags adicionais                                          | map(string)          | {}                                  |

## Outputs

| Nome                  | Descricao                              |
|-----------------------|------------------------------------------|
| security_group_id     | ID do Security Group criado              |
| security_group_arn    | ARN do Security Group criado             |
| security_group_name   | Nome do Security Group criado            |
| security_group_vpc_id | ID da VPC associada ao Security Group    |

## Boas praticas aplicadas

- Nenhuma regra abre `0.0.0.0/0` para portas de entrada por padrao.
- Regras de entrada e saida sao explicitas e configuraveis via variaveis.
- VPC e informada via variavel, sem depender da VPC default da conta.
- Nenhum valor sensivel ou credencial fixa no codigo.

## Validacao

```
terraform init -backend=false
terraform validate
```
