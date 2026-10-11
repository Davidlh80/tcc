# Security Group - Blueprint Terraform

Este modulo provisiona um Security Group na AWS dentro de uma VPC existente, com regras de entrada e saida configuraveis via variaveis, sem abertura irrestrita por padrao.

## Recursos criados

- `aws_security_group.this`: Security Group associado a uma VPC informada via variavel.

## Requisitos

- Terraform >= 1.5.0
- Provider AWS `~> 5.0`
- Uma VPC previamente criada (ID informado via `vpc_id`).

## Uso

```hcl
module "security_group" {
  source = "./"

  region      = "us-east-1"
  vpc_id      = "vpc-0123456789abcdef0"
  name        = "sg-app"
  description = "Security Group da aplicacao"

  ingress_rules = [
    {
      description = "Acesso HTTPS"
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

## Variaveis

| Nome            | Descricao                                             | Tipo   | Default                              |
|-----------------|--------------------------------------------------------|--------|---------------------------------------|
| region          | Regiao AWS                                              | string | `"us-east-1"`                        |
| vpc_id          | ID da VPC onde o Security Group sera criado             | string | obrigatorio                          |
| name            | Nome do Security Group                                  | string | `"sg-custom"`                        |
| description     | Descricao do Security Group                             | string | `"Security Group gerenciado via Terraform."` |
| ingress_rules   | Lista de regras de entrada                               | list(object) | `[]`                            |
| egress_rules    | Lista de regras de saida                                 | list(object) | regra HTTPS (443) de saida      |
| tags            | Tags adicionais                                          | map(string) | `{}`                            |

## Outputs

| Nome                 | Descricao                              |
|----------------------|------------------------------------------|
| security_group_id    | ID do Security Group criado              |
| security_group_arn   | ARN do Security Group criado             |
| security_group_name  | Nome do Security Group criado            |
| vpc_id               | ID da VPC associada ao Security Group    |

## Observacoes de seguranca

- Nenhuma regra de entrada e criada por padrao; e necessario declarar explicitamente `ingress_rules` com CIDRs restritos ao uso real.
- A regra de saida padrao libera apenas a porta 443 (HTTPS); regras adicionais devem ser adicionadas conforme a necessidade, evitando liberar todas as portas e protocolos sem motivo.
- Evite usar `0.0.0.0/0` em regras de entrada; prefira CIDRs especificos (ex.: faixa da VPC ou da rede corporativa).

## Validacao

```bash
terraform init -backend=false
terraform validate
```
