resource "aws_vpc" "dev_env" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = "dev-env"
  }
}

resource "aws_subnet" "dev_public" {
  vpc_id                  = aws_vpc.dev_env.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    "Name" = "dev-public"
  }
}

resource "aws_internet_gateway" "dev_gateway" {
  vpc_id = aws_vpc.dev_env.id

  tags = {
    "Name" = "dev-gateway"
  }
}

resource "aws_route_table" "dev_route_table" {
  vpc_id = aws_vpc.dev_env.id

  tags = {
    "Name" = "dev-route-table"
  }
}

resource "aws_route" "dev_public_route" {
  route_table_id         = aws_route_table.dev_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_gateway.id

}

resource "aws_route_table_association" "dev_route_table_association" {
  subnet_id      = aws_subnet.dev_public.id
  route_table_id = aws_route_table.dev_route_table.id
}

resource "aws_security_group" "dev_public_group" {
  name        = "dev-security-group"
  description = "dev-security-group"

  vpc_id = aws_vpc.dev_env.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "dev_ssh_key" {
  key_name   = "dev-ssh-key"
  public_key = file("/home/markon/.ssh/dev-env-key.pub")
}

resource "aws_instance" "dev_server_public" {
  ami                         = data.aws_ami.dev_server_ami.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.dev_ssh_key.key_name
  subnet_id                   = aws_subnet.dev_public.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.dev_public_group.id]
  user_data = file("userdata.tpl")
  
  root_block_device {
    volume_size = 10
  }
  
  tags = {
    Name = "dev-server-public"
  }

  provisioner "local-exec" {
    command = templatefile("ssh_config.tpl", {
        user = "ubuntu",
        hostname = self.public_ip,
        key_file = "/home/markon/.ssh/dev-env-key",
    })
    interpreter = ["bash", "-c"]
}

}
