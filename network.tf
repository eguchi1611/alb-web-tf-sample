resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "main" {
  route_table_id = aws_vpc.main.main_route_table_id
  subnet_id      = aws_subnet.public.id
}

resource "aws_route" "main" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  security_group_id = aws_vpc.main.default_security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
}
