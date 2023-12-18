# Create a VPC
resource "aws_vpc" "nmstokyovpc" {
  cidr_block = var.vpc_cidr
  tags       = var.vpc_tags

}

resource "aws_internet_gateway" "nmsIGW" {
  vpc_id = aws_vpc.nmstokyovpc.id
  tags = {
    Name    = "nmsIGW"
    Project = "nmsProject"
  }

}

resource "aws_eip" "nmsNATGWEIP1" {
  tags = {
    Name    = "nmsNATGWEIP1"
    Project = "nmsProject"
  }

}

resource "aws_nat_gateway" "nmsNATGW1" {
  allocation_id = aws_eip.nmsNATGWEIP1.id
  subnet_id     = aws_subnet.nmsPublicsubnet1.id
  tags = {
    Name    = "NATGW1"
    Project = "nmsProject"
  }

}

resource "aws_subnet" "nmsPublicsubnet1" {
  vpc_id            = aws_vpc.nmstokyovpc.id
  cidr_block        = var.public_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
  tags = {
    Name    = "nmsPublicsubnet1"
    Project = "nmsProject"
  }


}


resource "aws_eip" "nmsNATGWEIP2" {
  tags = {
    Name    = "nmsNATGWEIP2"
    Project = "nmsProject"
  }

}

resource "aws_nat_gateway" "nmsNATGW2" {
  allocation_id = aws_eip.nmsNATGWEIP2.id
  subnet_id     = aws_subnet.nmsPublicsubnet2.id
  tags = {
    Name    = "NATGW2"
    Project = "nmsProject"
  }

}

resource "aws_subnet" "nmsPublicsubnet2" {
  vpc_id            = aws_vpc.nmstokyovpc.id
  cidr_block        = var.public_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
  tags = {
    Name    = "nmsPublicsubnet2"
    Project = "nmsProject"
  }


}

resource "aws_subnet" "nmsPrivatesubnet1" {
  vpc_id            = aws_vpc.nmstokyovpc.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
  tags = {
    Name    = "nmsPrivatesubnet1"
    Project = "nmsProject"
  }


}
resource "aws_subnet" "nmsPrivatesubnet2" {
  vpc_id            = aws_vpc.nmstokyovpc.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
  tags = {
    Name    = "nmsPrivatesubnet2"
    Project = "nmsProject"
  }


}

resource "aws_route_table" "nmsPublicRT" {
  vpc_id = aws_vpc.nmstokyovpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nmsIGW.id
  }
  tags = {
    Name    = "nmsPublicRT"
    Project = "nmsProject"

  }
}

resource "aws_route_table" "nmsPrivateRT1" {
  vpc_id = aws_vpc.nmstokyovpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nmsNATGW1.id
  }
  tags = {
    Name    = "nmsPrivateRT1"
    Project = "nmsProject"

  }
}

resource "aws_route_table_association" "nmsPublicRTass1" {
  subnet_id      = aws_subnet.nmsPublicsubnet1.id
  route_table_id = aws_route_table.nmsPublicRT.id
}

resource "aws_route_table_association" "nmsPublicRTass2" {
  subnet_id      = aws_subnet.nmsPublicsubnet2.id
  route_table_id = aws_route_table.nmsPublicRT.id
}