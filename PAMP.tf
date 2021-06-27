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