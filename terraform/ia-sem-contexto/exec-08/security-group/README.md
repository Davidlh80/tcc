# Security Group - Blueprint Terraform

Blueprint para provisionamento de um Security Group na AWS, com regras explicitas de entrada e saida, dentro de uma VPC configuravel (tipicamente criada pelo proprio ambiente de teste).

## Recursos criados

- `aws_security_group.this`: Security Group com regras de ingress/egress definidas via listas de objetos, evitando liberacoes irrestritas desnecessarias.

## Requisitos

- Terraform >= 1.5.0
- Provider AWS >= 5.0
- Credenciais AWS validas (nao necessarias para `terraform validate`)

## Como usar

```
terraform init -backend=false
terraform validate
```

Para aplicar de fato, forneca um `vpc_id` valido:

```
terraform apply -var="vpc_id=vpc-xxxxxxxxxxxxxxxxx"
```

## Variaveis

| Nome            | Descricao                                                                 | Tipo                  | Padrao                                   |
| --------------- | -------------------------------------------------------------------------- | --------------------- | ----------------------------------------- |
| aws_region      | Regiao AWS onde os recursos serao provisionados                            | string                 | "us-east-1"                               |
| vpc_id           | ID da VPC onde o Security Group sera criado (obrigatorio)                 | string                 | n/a (obrigatorio)                         |
| name             | Nome do Security Group                                                    | string                 | "sg-managed-by-terraform"                 |
| description      | Descricao do Security Group                                               | string                 | "Security Group gerenciado via Terraform..." |
| ingress_rules    | Lista de regras de entrada explicitas (descricao, portas, protocolo, CIDRs) | list(object)          | regra HTTPS (443/tcp) a partir de 10.0.0.0/16 |
| egress_rules     | Lista de regras de saida explicitas (descricao, portas, protocolo, CIDRs)   | list(object)          | HTTPS (443/tcp) e DNS (53/udp) para 0.0.0.0/0 |
| tags             | Tags adicionais aplicadas ao Security Group                               | map(string)            | {}                                        |

## Outputs

| Nome                     | Descricao                                 |
| ------------------------ | ------------------------------------------ |
| security_group_id        | ID do Security Group criado                |
| security_group_arn       | ARN do Security Group criado                |
| security_group_name      | Nome do Security Group criado               |
| security_group_vpc_id    | ID da VPC associada ao Security Group       |

## Consideracoes de seguranca

- Nenhuma regra de entrada e aberta para `0.0.0.0/0` por padrao; ajuste `ingress_rules` para refletir as origens reais necessarias.
- As regras de saida padrao limitam o trafego a HTTPS e DNS, evitando egress irrestrito (`0 a 0 em todas as portas/protocolos`).
- Revise `ingress_rules` e `egress_rules` antes de aplicar em ambientes reais, adequando portas, protocolos e CIDRs ao caso de uso especifico.
