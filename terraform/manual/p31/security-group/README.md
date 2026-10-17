# Blueprint Security Group

Cria um Security Group em uma VPC definida pelo usuario. As regras de entrada
sao TCP e resultam do produto cartesiano entre `allowed_ports` e
`allowed_cidrs`. A lista de saida tambem precisa ser declarada e nao permite
`0.0.0.0/0`; ambas as direcoes ficam sem regras por padrao.

## Variaveis

| Variavel | Tipo | Obrigatoria | Descricao |
|---|---|---:|---|
| `aws_region` | `string` | Sim | Regiao AWS do provider. |
| `security_group_name` | `string` | Sim | Sufixo descritivo; o ambiente e prefixado ao nome. |
| `vpc_id` | `string` | Sim | ID da VPC. |
| `environment` | `string` | Sim | `dev`, `staging` ou `prod`. |
| `description` | `string` | Sim | Justificativa funcional do grupo. |
| `allowed_ports` | `list(number)` | Nao | Portas TCP de entrada; padrao `[]`. |
| `allowed_cidrs` | `list(string)` | Nao | CIDRs IPv4 de entrada; padrao `[]`. |
| `egress_rules` | `list(object)` | Nao | Regras TCP de saida; padrao `[]`. Cada objeto contem `description`, `port` e `cidr_ipv4`. |
| `additional_tags` | `map(string)` | Nao | Tags adicionais; padrao `{}`. |

## Outputs

`security_group_id`, `security_group_arn` e `security_group_name`.

## Exemplo

```hcl
aws_region          = "us-east-1"
security_group_name = "api"
vpc_id              = "vpc-0123456789abcdef0"
environment         = "dev"
description         = "Acesso HTTPS da rede interna para o servico API."
allowed_ports       = [443]
allowed_cidrs       = ["10.20.0.0/16"]
egress_rules = [
  {
    description = "HTTPS para servicos de atualizacao internos"
    port        = 443
    cidr_ipv4   = "10.30.0.0/16"
  }
]
```

Adapte os CIDRs e portas a topologia aprovada. Mantenha os valores em um
`terraform.tfvars` local e nao inclua credenciais AWS nesse arquivo.
