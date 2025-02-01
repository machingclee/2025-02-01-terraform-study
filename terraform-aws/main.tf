
module "networking" {
  source                 = "./modules/networking"
  vpc_cidr               = "10.123.0.0/16"
  public_cidrs           = ["10.123.2.0/24", "10.123.4.0/24"]
  private_cidrs          = ["10.123.1.0/24", "10.123.3.0/24", "10.123.5.0/24"]
  access_ip              = var.access_ip
  create_db_subnet_group = true
}


module "database" {
  source                 = "./modules/database"
  db_storage             = 10
  db_engine              = "mysql"
  db_engine_version      = "5.7.22"
  db_instance_class      = "db.t2.micro"
  db_name                = "james"
  db_username            = "james"
  db_password            = "jamesjames2025!"
  db_identifier          = "james_love_love_db"
  skip_final_snapshot    = true
  db_subnet_group_name   = ""
  vpc_security_group_ids = []

}
