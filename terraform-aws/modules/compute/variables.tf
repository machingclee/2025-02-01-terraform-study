variable "instance_count" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "public_security_gp_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "vol_size" {
  type = number
}

variable "key_name" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "user_data_path" {
  type = string
}

variable "db_user" {
  type = string
}
variable "db_password" {
  type = string
}
variable "db_endpoint" {
  type = string
}
variable "db_name" {
  type = string
}

variable "ec2_security_group_id" {
  type = string
}

variable "james_target_group_arn" {
  type = string
}

