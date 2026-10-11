# Security Group (AWS) — Blueprint Terraform

Blueprint para provisionamento de um Security Group dentro de uma VPC configurável (não utiliza a VPC default da conta).

## Recursos criados

- `aws_security_group.this`: Security Group com regras explícitas de entrada e saída, sem liberações irrestritas desnecessárias.

## Padrões de segurança adotados

- Nenhuma regra padrão libera todas as portas/protocolos (`0.0.0.0/0` em todas as portas).
- A regra de entrada padrão restringe HTTPS (443) a uma faixa de rede interna (`10.0.0.0/8`), ajustável via variável.
- A regra de saída padrão restringe o tráfego a HTTPS (443), em vez de liberar todo o tráfego de saída.
- Todas as regras de entrada e saída são declaradas de forma explícita e configurável via listas de objetos.

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-xxxxxxxx"
  name   = "app-sg"

  ingress_rules = [
    {
      description = "Permite HTTPS a partir da rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]

  egress_rules = [
    {
      description = "Permite trafego de saida HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "test"
  }
}
```

## Inputs

| Nome            | Descrição                                                                 | Tipo                      | Default                     |
|-----------------|----------------------------------------------------------------------------|----------------------------|------------------------------|
| aws_region      | Região AWS onde os recursos serão provisionados                           | `string`                   | `"us-east-1"`                |
| vpc_id          | ID da VPC onde o Security Group será criado (não deve ser a VPC default)  | `string`                   | —                            |
| name            | Nome do Security Group                                                     | `string`                   | `"app-sg"`                   |
| description     | Descrição do Security Group                                               | `string`                   | `"Security group gerenciado via Terraform"` |
| ingress_rules   | Lista de regras explícitas de entrada                                      | `list(object({...}))`      | ver `variables.tf`           |
| egress_rules    | Lista de regras explícitas de saída                                        | `list(object({...}))`      | ver `variables.tf`           |
| tags            | Tags adicionais aplicadas ao recurso                                       | `map(string)`               | `{}`                         |

## Outputs

| Nome                  | Descrição                                   |
|-----------------------|----------------------------------------------|
| security_group_id     | ID do Security Group criado                  |
| security_group_arn    | ARN do Security Group criado                  |
| security_group_name   | Nome do Security Group criado                  |
| vpc_id                | ID da VPC associada ao Security Group          |

## Validação

```
terraform init -backend=false
terraform validate
```
