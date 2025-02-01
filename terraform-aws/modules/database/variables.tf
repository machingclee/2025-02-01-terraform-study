variable "db_storage" {
  type        = number
  description = "Should be an integer in GB"
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type = string
}


variable "db_instance_class" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}


variable "db_subnet_group_name" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "db_identifier" {
  type = string
}

variable "skip_final_snapshot" {
  type = bool
}
