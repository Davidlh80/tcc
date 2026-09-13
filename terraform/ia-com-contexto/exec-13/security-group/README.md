# Security Group

## 1. Visao geral

Este modulo cria um Security Group na AWS com nome padronizado no formato `<ambiente>-<sistema>-sg-<finalidade>`, aplicando as tags obrigatorias da organizacao e permitindo a configuracao explicita de regras de entrada e saida via variaveis.

Restricoes de seguranca aplicadas por padrao:

- `0.0.0.0/0` so e permitido em regras de entrada ou saida quando a porta for exatamente `443/tcp`; qualquer outra combinacao com `0.0.0.0/0` falha na validacao das variaveis.
- Toda regra de entrada e de saida exige uma descricao nao vazia.
- Nenhuma regra de entrada ou saida e criada por padrao (`ingress_rules` e `egress_rules` comecam vazias); o egress deve ser declarado explicitamente pelo consumidor do modulo.

## 2. Variaveis

| Nome                  | Tipo                    | Obrigatoria | Descricao                                                                          |
|-----------------------|-------------------------|-------------|-------------------------------------------------------------------------------------|
| `environment`         | `string`                | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                     |
| `system`               | `string`                | Sim         | Identificador do sistema ou aplicacao dono do recurso.                              |
| `region`               | `string`                | Sim         | Regiao AWS onde os recursos serao provisionados.                                    |
| `additional_tags`      | `map(string)`           | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.                    |
| `security_group_name`  | `string`                | Sim         | Finalidade do Security Group, usada na composicao do nome (ex.: `web`, `database`). |
| `vpc_id`               | `string`                | Sim         | ID da VPC onde o Security Group sera criado.                                        |
| `ingress_rules`        | `list(object)`          | Nao         | Regras de entrada (descricao, portas, protocolo, cidr_blocks). Padrao: `[]`.         |
| `egress_rules`         | `list(object)`          | Nao         | Regras de saida (descricao, portas, protocolo, cidr_blocks). Padrao: `[]`.           |

## 3. Outputs

| Nome                    | Descricao                          |
|-------------------------|-------------------------------------|
| `security_group_name`   | Nome do Security Group criado.      |
| `security_group_arn`    | ARN do Security Group criado.       |
| `security_group_id`     | ID do Security Group criado.        |

## 4. Exemplo de uso

```hcl
module "sg_web" {
  source = "./"

  environment         = "hml"
  system              = "tcc"
  region              = "us-east-1"
  security_group_name = "web"
  vpc_id              = "vpc-0123456789abcdef0"

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
      description = "Saida HTTPS para atualizacoes de pacotes"
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
