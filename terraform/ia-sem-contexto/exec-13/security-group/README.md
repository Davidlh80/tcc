# Security Group (Terraform)

Blueprint Terraform para provisionamento de um Security Group na AWS, com regras explicitas de entrada e saida, dentro de uma VPC configuravel via variavel.

## Recursos criados

- `aws_security_group.this`: Security Group com regras de ingress/egress definidas dinamicamente a partir de listas de objetos.

## Requisitos

- Terraform >= 1.5.0
- Provider AWS (`hashicorp/aws`) ~> 5.0

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "sg-app-exemplo"

  ingress_rules = [
    {
      description = "HTTPS da rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Inputs

| Nome            | Descricao                                                             | Tipo   | Default                                  |
|-----------------|------------------------------------------------------------------------|--------|-------------------------------------------|
| aws_region      | Regiao AWS onde os recursos serao provisionados                       | string | `"us-east-1"`                            |
| vpc_id          | ID da VPC onde o Security Group sera criado                           | string | (obrigatorio)                            |
| name            | Nome do Security Group                                                 | string | `"sg-app"`                               |
| description     | Descricao do Security Group                                            | string | `"Security Group gerenciado via Terraform"` |
| ingress_rules   | Lista de regras de entrada (description, from_port, to_port, protocol, cidr_blocks) | list(object) | HTTPS interno (10.0.0.0/16)       |
| egress_rules    | Lista de regras de saida (description, from_port, to_port, protocol, cidr_blocks)    | list(object) | HTTPS externo + DNS interno       |
| tags            | Tags adicionais aplicadas ao recurso                                    | map(string) | `{}`                               |

## Outputs

| Nome                 | Descricao                                   |
|----------------------|----------------------------------------------|
| security_group_id    | ID do Security Group criado                   |
| security_group_arn   | ARN do Security Group criado                  |
| security_group_name  | Nome do Security Group criado                 |
| vpc_id               | ID da VPC associada ao Security Group         |

## Consideracoes de seguranca

- Nenhuma regra padrao libera entrada irrestrita (`0.0.0.0/0`) para qualquer porta; a regra de entrada padrao restringe-se a HTTPS originado da faixa interna da VPC.
- A regra de saida padrao para HTTPS usa `0.0.0.0/0` apenas porque e um padrao comum para acesso a APIs/pacotes externos; ajuste `egress_rules` para restringir ainda mais conforme a necessidade do ambiente.
- Revise `ingress_rules` e `egress_rules` antes de aplicar em producao, adequando portas, protocolos e CIDRs ao caso de uso real.
- `vpc_id` deve apontar para a VPC criada pelo proprio ambiente de teste, nao para a VPC padrao da conta.
