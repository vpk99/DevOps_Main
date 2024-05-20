# Creating vpc
resource "aws_vpc" "ntier" {
  cidr_block = var.network_info.cidr
  tags = {
    Name = var.network_info.name
  }
}



# creating private subnets 

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.ntier.id
  cidr_block        = var.private_subnets[count.index].cidr_block
  availability_zone = var.private_subnets[count.index].az

  tags = {
    Name = var.private_subnets[count.index].name
  }
  depends_on = [aws_vpc.ntier]

}

# Creating public subnets 

resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.ntier.id
  cidr_block        = var.public_subnets[count.index].cidr_block
  availability_zone = var.public_subnets[count.index].az

  tags = {
    Name = var.public_subnets[count.index].name
  }
  depends_on = [aws_vpc.ntier]
}

# Creating internet gateway and attach to vpc

resource "aws_internet_gateway" "ntier" {
  vpc_id = aws_vpc.ntier.id
  tags = {
    Name = "ntier"
  }
  depends_on = [aws_vpc.ntier]
}

# Creating Route table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ntier.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ntier.id
  }
  tags = {
    Name = "public_rt"
  }
  depends_on = [aws_vpc.ntier, aws_vpc.ntier, aws_subnet.public]
}

# Associate the public route table to public subnets

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
  depends_on     = [aws_route_table.public, aws_subnet.public]
}

