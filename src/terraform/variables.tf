variable "usuario_banco" {
  description = "Usuário banco de dados"
  type        = string
  sensitive   = true
}

variable "senha_banco" {
  description = "Senha banco de dados"
  type        = string
  sensitive   = true
}

variable "conexao_banco" {
  description = "Conexão banco de dados"
  type        = string
  sensitive   = true
}