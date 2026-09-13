# Security Group

## Visao geral do recurso

Este modulo provisiona um AWS Security Group seguindo os padroes organizacionais de nomenclatura, tags e governanca de Infraestrutura como Codigo.

O recurso e criado na VPC informada por variavel e aplica as seguintes regras de seguranca:

- o CIDR `0.0.0.0/0` e proibido em qualquer porta diferente de `443/tcp`;
- toda regra de entrada e de saida exige uma descricao obrigatoria;
- as regras de egress sao declaradas explicitamente, sem liberacao irrestrita por padrao (apenas `443/tcp` e liberado por padrao);
- as regras de entrada e saida sao totalmente configuraveis por variavel;
- nenhuma regra de entrada e criada por padrao, seguindo o principio do menor privilegio.

O nome do recurso segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo `hml-tcc-sg-web`.

## Tabela de variaveis

| Nome                  | Tipo                  | Obrigatoria | Descricao                                                                                          |
|-----------------------|-----------------------|-------------|------------------------------------------------------------------------------------------------------|
| `environment`         | `string`              | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                      |
| `system`              | `string`              | Nao         | Nome do sistema ou aplicacao ao qual o recurso pertence. Padrao: `tcc`.                               |
| `region`              | `string`              | Nao         | Regiao AWS onde o recurso sera provisionado. Padrao: `us-east-1`.                                     |
| `additional_tags`     | `map(string)`         | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                          |
| `security_group_name` | `string`              | Sim         | Finalidade do Security Group, utilizada na composicao do nome (ex.: `web`, `database`, `bastion`).    |
| `description`         | `string`              | Sim         | Descricao do Security Group.                                                                           |
| `vpc_id`              | `string`              | Sim         | ID da VPC onde o Security Group sera criado.                                                          |
| `ingress_rules`       | `list(object({...}))` | Nao         | Lista de regras de entrada, cada uma com `description`, `from_port`, `to_port`, `protocol` e `cidr_blocks`. Padrao: `[]`. |
| `egress_rules`        | `list(object({...}))` | Nao         | Lista de regras de saida, cada uma com `description`, `from_port`, `to_port`, `protocol` e `cidr_blocks`. Padrao: regra unica liberando `443/tcp`. |

## Tabela de outputs

| Nome                    | Descricao                              |
|-------------------------|------------------------------------------|
| `security_group_name`   | Nome do Security Group criado.           |
| `security_group_arn`    | ARN do Security Group criado.            |
| `security_group_id`     | ID do Security Group criado.             |

## Exemplo de uso

```hcl
module "sg_web" {
  source = "./"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  security_group_name  = "web"
  description          = "Security Group para o servico web hml-tcc."
  vpc_id               = "vpc-0123456789abcdef0"

  ingress_rules = [
    {
      description = "Permite trafego HTTPS de entrada da internet."
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      description = "Permite trafego de saida HTTPS."
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
