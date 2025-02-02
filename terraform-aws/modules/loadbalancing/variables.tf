
variable "public_security_groups" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "tg_port" {
  type = string
}
variable "tg_protocol" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "lb_healthy_threshold" {
  type = string
}
variable "lb_unhealthy_threshold" {
  type = string
}
variable "lb_timeout" {
  type = number
}
variable "lb_interval" {
  type = number
}

variable "listener_port" {
  type = number
}

variable "listener_portocol" {
  type = string
}
