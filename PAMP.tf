# Create a VPC
resource "aws_vpc" "Motiva_Team1_VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Motiva_Team1_VPC"
  }
}

# Create a Public Subnet 
resource "aws_subnet" "Motiva_Team1_Public_SN_01" {
  vpc_id     = aws_vpc.Motiva_Team1_VPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "Motiva_Team1_Public_SN_0.1"
  }
}

resource "aws_subnet" "Motiva_Team1_Public_SN_02" {
  vpc_id     = aws_vpc.Motiva_Team1_VPC.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-2c"
  tags = {
    Name = "Motiva_Team1_Public_SN_0.2"
  }
}

# Create a Private Subnet 
resource "aws_subnet" "Motiva_Team1_Private_SN_01" {
  vpc_id     = aws_vpc.Motiva_Team1_VPC.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "Motiva_Team1_Private_SN_0.1"
  }
}
resource "aws_subnet" "Motiva_Team1_Private_SN_02" {
  vpc_id     = aws_vpc.Motiva_Team1_VPC.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-2c"
  tags = {
    Name = "Motiva_Team1_Private_SN_0.2"
  }
}
# Create an Internet Gateway 
resource "aws_internet_gateway" "Motiva_Team1_IGW" {
  vpc_id = aws_vpc.Motiva_Team1_VPC.id

  tags = {
    Name = "Motiva_Team1_IGW"
  }
}
#Create a NAT Gateway
 resource "aws_nat_gateway" "Motiva_Team1_NAT" {
  allocation_id = aws_eip.Motiva_Team1_EIP.id
  subnet_id     = aws_subnet.Motiva_Team1_Public_SN_01.id

  tags = {
    Name = "Motiva_Team1_NAT"
  }
}
#Create EIP for Nat Gateway
resource "aws_eip" "Motiva_Team1_EIP" {
  vpc       = true
}
#create Public route table, attach to the vpc. allow access from every ip. attach to internet gateway
resource "aws_route_table" "Motiva_Team1_RT_Pub_SN" {
  vpc_id = aws_vpc.Motiva_Team1_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Motiva_Team1_IGW.id
  }

  tags = {
    Name = "Motiva_team1_RT_Pub_SN"
  }
}
#create private route table, attach to the vpc. allow access from every ip. attach to nat-gateway
resource "aws_route_table" "Motiva_Team1_RT_Prv_SN" {
  vpc_id = aws_vpc.Motiva_Team1_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Motiva_Team1_NAT.id
  }

  tags = {
    Name = "Motiva_team1_RT_Prv_SN"
  }
}
#Associate subnets with route table
resource "aws_route_table_association" "Motiva_Team1_Public_RT-1" {
  subnet_id      = aws_subnet.Motiva_Team1_Public_SN_01.id
  route_table_id = aws_route_table.Motiva_Team1_RT_Pub_SN.id
}
resource "aws_route_table_association" "Motiva_Team1_Public_RT-2" {
  subnet_id      = aws_subnet.Motiva_Team1_Public_SN_02.id
  route_table_id = aws_route_table.Motiva_Team1_RT_Pub_SN.id
}
resource "aws_route_table_association" "Motiva_Team1_Private_RT-1" {
  subnet_id      = aws_subnet.Motiva_Team1_Private_SN_01.id
  route_table_id = aws_route_table.Motiva_Team1_RT_Prv_SN.id
}
resource "aws_route_table_association" "Motiva_Team1_Private_RT-2" {
  subnet_id      = aws_subnet.Motiva_Team1_Private_SN_02.id
  route_table_id = aws_route_table.Motiva_Team1_RT_Prv_SN.id
}
#create 2 frontend security group
resource "aws_security_group" "Motiva_Team1_FrontEnd_SG" {
  name        = "Motiva_Team1_FrontEnd_SG"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.Motiva_Team1_VPC.id
  ingress {
    description      = "SSH rule VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP rule VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Motiva_Team1_FrontEnd_SG"
  }
}
#create backend security group
resource "aws_security_group" "Motiva_Team1_BackEnd_SG" {
  name        = "Motiva_Team1_BackEnd_SG"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.Motiva_Team1_VPC.id
  ingress {
    description      = "SSH rule VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.1.0/24"]
  }
  ingress {
    description      = "MYSQL rule VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.0.1.0/24"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Motiva_Team1_BackEnd_SG"
  }
}
# Create S3 Media Bucket
resource "aws_s3_bucket" "motiva-team1-media" {
  bucket = "motiva-team1-media"
  acl    = "private"

  tags = {
    Name        = "motiva-team1-media"
    Environment = "Dev"
  }
}
#Create Backup Bucket
resource "aws_s3_bucket" "motiva-team1-backup" {
  bucket = "motiva-team1-backup"
  acl    = "private"

  tags = {
    Name        = "motiva-team1-backup"
    Environment = "Dev"
  }
}
# Attach a bucket policy to media bucket
resource "aws_s3_bucket_policy" "motiva-team1-policy" {
  bucket = aws_s3_bucket.motiva-team1-media.id

    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "motiva-team1-policy",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
    "Principal": "*",
      "Action": [
          "s3:GetObject"
          ],
      "Resource":[
          "arn:aws:s3:::motiva-team1-media/*"
      ]
    }
  ]
}
POLICY
}