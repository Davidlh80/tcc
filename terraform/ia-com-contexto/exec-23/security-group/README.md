# Security Group

## Visao geral

Este modulo provisiona um Security Group na AWS, associado a uma VPC informada por variavel. O modulo segue os padroes internos da organizacao:

- nomenclatura no formato `<ambiente>-<sistema>-sg-<finalidade>`;
- tags obrigatorias padronizadas;
- proibicao de `0.0.0.0/0` em qualquer porta diferente de 443/tcp, tanto em regras de entrada quanto de saida;
- descricao obrigatoria em toda regra de ingress e egress;
- egress declarado de forma explicita por variavel, sem liberacao irrestrita por padrao (nenhuma regra de saida e criada caso `egress_rules` nao seja informado);
- regras de entrada e saida totalmente configuraveis por variavel.

## Variaveis

| Nome                 | Tipo                                                                                          | Obrigatoria | Descricao                                                                                          |
|----------------------|------------------------------------------------------------------------------------------------|-------------|------------------------------------------------------------------------------------------------------|
| `environment`        | `string`                                                                                        | Sim         | Ambiente de implantacao do recurso (`dev`, `hml` ou `prd`).                                          |
| `system`              | `string`                                                                                        | Sim         | Nome do sistema ou projeto ao qual o recurso pertence.                                               |
| `region`              | `string`                                                                                        | Sim         | Regiao da AWS onde os recursos serao criados.                                                        |
| `additional_tags`     | `map(string)`                                                                                   | Nao         | Tags adicionais mescladas as tags obrigatorias da organizacao. Padrao: `{}`.                         |
| `vpc_id`              | `string`                                                                                        | Sim         | ID da VPC onde o Security Group sera criado.                                                         |
| `security_group_name` | `string`                                                                                        | Sim         | Finalidade do Security Group, usada na composicao do nome padronizado (ex.: `web`, `api`).           |
| `description`         | `string`                                                                                        | Nao         | Descricao geral do Security Group. Padrao: `"Security Group gerenciado via Terraform."`.             |
| `ingress_rules`       | `list(object({ description, from_port, to_port, protocol, cidr_blocks }))`                     | Nao         | Regras de entrada. `0.0.0.0/0` somente permitido em regras de porta 443/tcp. Padrao: `[]`.           |
| `egress_rules`        | `list(object({ description, from_port, to_port, protocol, cidr_blocks }))`                     | Nao         | Regras de saida. `0.0.0.0/0` somente permitido em regras de porta 443/tcp. Padrao: `[]` (sem egress). |

## Outputs

| Nome                   | Descricao                              |
|-------------------------|-----------------------------------------|
| `security_group_name`   | Nome do Security Group criado.          |
| `security_group_arn`    | ARN do Security Group criado.           |
| `security_group_id`     | ID do Security Group criado.            |

## Exemplo de uso

```hcl
module "sg_web" {
  source = "./security-group"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"

  ingress_rules = [
    {
      description = "Acesso HTTPS publico"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      description = "Saida HTTPS para atualizacoes e integracoes externas"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
