
module "networking" {
  source                 = "./modules/networking"
  vpc_cidr               = "10.123.0.0/16"                                     // this is used to create a custom VPC
  public_cidrs           = ["10.123.2.0/24", "10.123.4.0/24"]                  // this is for public subnets
  private_cidrs          = ["10.123.1.0/24", "10.123.3.0/24", "10.123.5.0/24"] // this is for privae subnets
  ssh_access_ip          = var.ssh_access_ip
  create_db_subnet_group = true
}



module "database" {
  source                 = "./modules/database"
  db_storage             = 10
  db_engine              = "mysql"
  db_engine_version      = "5.7.44"
  db_instance_class      = "db.t3.micro"
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  db_identifier          = "james-love-love-db"
  skip_final_snapshot    = true
  db_subnet_group_name   = length(module.networking.db_subnet_group_names) == 1 ? module.networking.db_subnet_group_names[0] : ""
  vpc_security_group_ids = [module.networking.db_security_group_id]
}


module "loadbalancing" {
  source                 = "./modules/loadbalancing"
  public_security_groups = [module.networking.public_http_sg.id, module.networking.public_ssh_sg.id]
  public_subnets         = module.networking.public_subnet_ids
  tg_port                = 8000
  tg_protocol            = "HTTP"
  vpc_id                 = module.networking.vpc_id
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 3
  lb_interval            = 30
  listener_port          = 8000
  listener_portocol      = "HTTP"
}
