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