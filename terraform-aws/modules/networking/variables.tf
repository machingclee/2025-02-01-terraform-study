variable "vpc_cidr" {
  type = string
}

variable "public_cidrs" {
  type = list(string)
}


variable "private_cidrs" {
  type = list(string)
}

variable "ssh_access_ip" {
  type = string
}

variable "create_db_subnet_group" {
  type = bool
}
