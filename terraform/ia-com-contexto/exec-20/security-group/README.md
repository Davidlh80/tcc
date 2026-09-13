# Security Group

## Visao geral

Este modulo Terraform cria um Security Group na AWS, com o ID da VPC configuravel por variavel. As regras de entrada e saida sao definidas por variaveis do tipo lista de objetos, exigindo descricao obrigatoria em cada regra. O uso de `0.0.0.0/0` e proibido em qualquer regra, exceto quando a porta for 443/tcp. Nenhuma regra de egress e criada por padrao (lista vazia), evitando liberacao irrestrita de saida; o egress deve ser declarado explicitamente pelo consumidor do modulo. O recurso segue o padrao de nomenclatura `<ambiente>-<sistema>-sg-<finalidade>` e aplica o conjunto de tags obrigatorias da organizacao.

## Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|------|------|-------------|-----------|
| environment | string | sim | Ambiente de implantacao (`dev`, `hml` ou `prd`). |
| system | string | sim | Nome do sistema ou aplicacao dono do recurso. |
| region | string | nao | Regiao AWS onde o Security Group sera criado. Padrao: `us-east-1`. |
| additional_tags | map(string) | nao | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`. |
| security_group_name | string | sim | Finalidade do Security Group, usada na composicao do nome padronizado. |
| vpc_id | string | sim | ID da VPC onde o Security Group sera criado. |
| ingress_rules | list(object) | nao | Regras de entrada (`description`, `from_port`, `to_port`, `protocol`, `cidr_blocks`). `0.0.0.0/0` so e permitido em `tcp/443`. Padrao: `[]`. |
| egress_rules | list(object) | nao | Regras de saida (`description`, `from_port`, `to_port`, `protocol`, `cidr_blocks`). `0.0.0.0/0` so e permitido em `tcp/443`. Padrao: `[]` (sem egress). |

## Outputs

| Nome | Descricao |
|------|-----------|
| security_group_id | ID do Security Group criado. |
| security_group_arn | ARN do Security Group criado. |
| security_group_name | Nome padronizado do Security Group criado. |

## Exemplo de uso

```hcl
module "sg_web" {
  source = "./security-group"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  security_group_name  = "web"
  vpc_id               = "vpc-0123456789abcdef0"

  ingress_rules = [
    {
      description = "Acesso HTTPS publico"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Acesso SSH restrito a rede interna"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Saida HTTPS para atualizacoes"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  additional_tags = {
    Team = "platform"
  }
}
```
