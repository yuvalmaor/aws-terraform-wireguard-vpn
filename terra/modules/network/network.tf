# Create a VPC
resource "aws_vpc" "yuval-terraform-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "${var.env}-yuval-terraform-vpc" }
}

# Create a AWS internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.yuval-terraform-vpc.id
  tags   = { Name = "${var.env}-yuval-terraform-igw" }
}

# create public subnets
resource "aws_subnet" "subnets" {
  count                   = var.num_of_subnets
  vpc_id                  = aws_vpc.yuval-terraform-vpc.id
  cidr_block              = var.cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.env}-yuval-terraform-subnet-${count.index}" }
}


resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.yuval-terraform-vpc.id
  tags   = { Name = "${var.env}-yuval-terraform-routetable" }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "route_table_a1" {
  count          = var.num_of_subnets
  route_table_id = aws_route_table.route_table.id
  subnet_id      = aws_subnet.subnets[count.index].id
}


resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.yuval-terraform-vpc.id
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 5000
    to_port     = 5000
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "udp"
    from_port   = 51820
    to_port     = 51820
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "udp"
    from_port   = 53
    to_port     = 53
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0  
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.env}-yuval-terraform-sg" }
}
