data "aws_ami" "server_ami" {
  most_recent = true
  # it can be found in ec2 > Images > AMIs > Public Images
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}


resource "random_id" "james_node_id" {
  byte_length = 2
  count       = var.instance_count
  # this acts like an identifier in a map, and will create another 
  # random_id with the same key_name

  /*
    The random_id resource with count will generate different random IDs, but it won't create additional instances by itself. The number of instances is controlled by var.instance_count.
    If var.instance_count = 1, you'll only get one instance regardless of random IDs. To create more instances:
    */

  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "james_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "james_node" {
  count                  = var.instance_count # 1
  instance_type          = var.instance_type  # t3.micro
  security_groups        = [var.ec2_security_group_id]
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.james_auth.key_name
  vpc_security_group_ids = var.public_security_gp_ids
  subnet_id              = var.public_subnet_ids[count.index]
  user_data = templatefile(var.user_data_path, {
    nodename    = "james-node-${random_id.james_node_id[count.index].dec}"
    dbuser      = var.db_user
    dbpass      = var.db_password
    db_endpoint = var.db_endpoint
    dbname      = var.db_name
  })
  root_block_device {
    volume_size = var.vol_size # 10
  }
  tags = {
    Name = "james_node-${random_id.james_node_id[count.index].dec}"
  }
}

# attach EC2 instances (target_id's) to the target group (target_group_arn)
resource "aws_lb_target_group_attachment" "james_tg_attach" {
  count            = var.instance_count
  target_group_arn = var.james_target_group_arn
  target_id        = aws_instance.james_node[count.index].id
  // port = 8000 target port of the EC2, this will override the port in target group on a per instance basis
}