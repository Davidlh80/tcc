# Security Group

## 1. Visao geral

Este modulo cria um AWS Security Group com nomenclatura padronizada
`<ambiente>-<sistema>-sg-<finalidade>` e tags obrigatorias da organizacao.

O recurso segue o principio do menor privilegio: nenhuma regra de entrada ou
saida e criada por padrao (listas vazias), toda regra exige descricao
obrigatoria, e a liberacao para `0.0.0.0/0` so e permitida quando a regra usa
exatamente a porta 443/tcp. Como nao ha egress padrao definido pelo Terraform,
o Security Group nao possui liberacao irrestrita de saida por padrao.

## 2. Variaveis

| Nome                  | Tipo                  | Obrigatoria | Descricao                                                                                      |
|-----------------------|------------------------|:-----------:|--------------------------------------------------------------------------------------------------|
| environment            | string                 | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                 |
| system                 | string                 | Sim         | Nome do sistema/aplicacao, usado na composicao do nome padronizado.                              |
| region                 | string                 | Sim         | Regiao AWS onde o recurso sera criado.                                                           |
| additional_tags        | map(string)            | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Default: `{}`.                |
| security_group_name    | string                 | Sim         | Finalidade do Security Group, usada para compor `<ambiente>-<sistema>-sg-<finalidade>`.          |
| vpc_id                 | string                 | Sim         | ID da VPC onde o Security Group sera criado.                                                     |
| description            | string                 | Nao         | Descricao do Security Group. Default: "Security group gerenciado via Terraform.".                |
| ingress_rules          | list(object)           | Nao         | Regras de entrada (description, from_port, to_port, protocol, cidr_blocks). Default: `[]`.       |
| egress_rules           | list(object)           | Nao         | Regras de saida (description, from_port, to_port, protocol, cidr_blocks). Default: `[]`.         |

## 3. Outputs

| Nome                  | Descricao                              |
|-----------------------|------------------------------------------|
| security_group_name    | Nome do Security Group criado.           |
| security_group_arn     | ARN do Security Group criado.            |
| security_group_id      | ID do Security Group criado.             |

## 4. Exemplo de uso

module "security_group" {
  source = "./"

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
    Squad = "platform"
  }
}
