# Security Group (AWS) — Blueprint Terraform

Blueprint Terraform para provisionar um `aws_security_group` em uma VPC existente, com regras de entrada e saida totalmente configuraveis via variaveis.

## Recursos criados

- `aws_security_group.this`

## Requisitos

- Terraform >= 1.5.0
- Provider AWS ~> 5.0
- Uma VPC ja existente (o ID deve ser informado via `var.vpc_id`)

## Variaveis principais

| Nome            | Descricao                                      | Tipo                | Default                        |
|-----------------|-------------------------------------------------|---------------------|----------------------------------|
| `vpc_id`        | ID da VPC onde o SG sera criado (obrigatorio)   | `string`            | -                                |
| `name`          | Nome do Security Group                          | `string`            | `"sg-app"`                       |
| `description`   | Descricao do Security Group                     | `string`            | `"Security Group gerenciado via Terraform."` |
| `ingress_rules` | Lista de regras de entrada                      | `list(object(...))` | `[]`                             |
| `egress_rules`  | Lista de regras de saida                        | `list(object(...))` | Libera todo trafego de saida     |
| `tags`          | Tags adicionais                                 | `map(string)`       | `{}`                             |
| `aws_region`    | Regiao AWS onde o provider ira operar           | `string`            | `"us-east-1"`                    |

## Postura de seguranca padrao

- Nenhuma regra de entrada e liberada por padrao (`ingress_rules = []`); o consumidor do modulo deve declarar explicitamente as portas e origens necessarias.
- Recomenda-se evitar o uso de `0.0.0.0/0` em regras de entrada, restringindo os `cidr_blocks` aos ranges realmente necessarios.
- O trafego de saida e liberado por padrao, seguindo o comportamento padrao de Security Groups na AWS, mas pode ser restringido customizando `egress_rules`.

## Exemplo de uso

```
module "sg_web" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "sg-web"

  ingress_rules = [
    {
      description = "HTTPS publico"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Ambiente = "producao"
  }
}
```

## Validacao

```
terraform init -backend=false
terraform validate
```
