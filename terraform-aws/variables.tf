variable "aws_region" {
  default = "ap-northeast-1"
}

variable "ssh_access_ip" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}
