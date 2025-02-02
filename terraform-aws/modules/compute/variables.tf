variable "instance_count" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "public_security_gp_id" {
  type = string
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

