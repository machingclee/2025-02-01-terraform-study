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
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.james_auth.key_name
  vpc_security_group_ids = [var.public_security_gp_id]
  subnet_id              = var.public_subnet_ids[count.index]
  root_block_device {
    volume_size = var.vol_size # 10
  }
  tags = {
    Name = "james_node-${random_id.james_node_id[count.index].dec}"
  }
}

# generate an rsa key by ssh-keygen -t rsa


