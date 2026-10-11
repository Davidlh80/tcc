# Security Group - Blueprint Terraform

Blueprint para provisionamento de um Security Group na AWS, projetado para ser testado dentro de uma VPC criada pelo proprio ambiente de teste (nao a VPC padrao da conta).

## Recursos criados

- `aws_security_group.this`: Security Group associado a VPC informada em `var.vpc_id`.
- `aws_security_group_rule.ingress`: regras explicitas de entrada, definidas via `var.ingress_rules`.
- `aws_security_group_rule.egress`: regras explicitas de saida, definidas via `var.egress_rules`.

## Decisoes de seguranca

- Nenhuma regra padrao abre todas as portas (`0-65535`) ou todos os protocolos (`-1`) irrestritamente.
- O padrao de ingress libera apenas a porta `443/tcp` a partir de um bloco CIDR interno configuravel (`10.0.0.0/16` por padrao), nao de `0.0.0.0/0`.
- O padrao de egress libera apenas a porta `443/tcp` para a internet, suficiente para atualizacoes e chamadas a APIs externas, evitando liberar todo o trafego de saida.
- As regras sao totalmente substituiveis via `var.ingress_rules` e `var.egress_rules`, permitindo adequar portas e origens ao caso de uso real sem alterar o codigo.

## Variaveis

| Nome            | Descricao                                             | Tipo                  | Default                                    |
|-----------------|--------------------------------------------------------|-----------------------|---------------------------------------------|
| `vpc_id`        | ID da VPC onde o Security Group sera criado            | `string`              | obrigatorio                                 |
| `aws_region`    | Regiao AWS utilizada pelo provider                      | `string`              | `us-east-1`                                 |
| `name`          | Nome do Security Group                                  | `string`              | `sg-managed`                                |
| `description`   | Descricao do Security Group                             | `string`              | `Security Group gerenciado via Terraform.`  |
| `ingress_rules` | Lista de regras de entrada (descricao, portas, protocolo, CIDRs) | `list(object)` | regra HTTPS a partir de `10.0.0.0/16`       |
| `egress_rules`  | Lista de regras de saida (descricao, portas, protocolo, CIDRs)   | `list(object)` | regra HTTPS de saida para `0.0.0.0/0`       |
| `tags`          | Tags adicionais aplicadas ao recurso                    | `map(string)`         | `{}`                                        |

## Outputs

| Nome                   | Descricao                                 |
|------------------------|---------------------------------------------|
| `security_group_id`    | ID do Security Group criado                |
| `security_group_arn`   | ARN do Security Group criado               |
| `security_group_name`  | Nome do Security Group criado              |
| `vpc_id`               | ID da VPC associada ao Security Group      |

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"

  ingress_rules = [
    {
      description = "HTTPS a partir da rede corporativa"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["203.0.113.0/24"]
    }
  ]
}
```

## Validacao local

```bash
terraform init -backend=false
terraform validate
terraform fmt -check
```
