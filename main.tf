# add private subnet with cidr 10.0.1.0/24
resource "aws_subnet" "private" {
  vpc_id = data.aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  
}

# add routing table for private subnet
resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.vpc.id
  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = data.aws_nat_gateway.nat.id
    }
}

# associate routing table with private subnet
resource "aws_route_table_association" "private" {
  subnet_id = subnet.private.id
  route_table_id = aws_route_table.private.id
}

# add security group for lambda function 
resource "aws_security_group" "lambda" {
  vpc_id = data.aws_vpc.vpc.id
  name = "request-Lambda-SG"
  description = "Allow inbound traffic from VPC"
}

# add security group rule for lambda function
# resource "aws_security_group_rule" "lambda" {
#   type = "ingress"
#   from_port = 443
#   to_port = 443
#   protocol = "tcp"
#   security_group_id = aws_security_group.lambda.id
# }

# add lambda function to POST a request to the following HTTPS endpoint: https://bc1yy8dzsg.execute-api.eu-west-1.amazonaws.com/v1/data using python 3.12
resource "aws_lambda_function" "request" {
  function_name = "request-1"
  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"
  role = data.aws_iam_role.lambda.arn
  vpc_config {
    subnet_ids = [subnet.private.id]
    security_group_ids = [aws_security_group.lambda.id]
  }
  environment {
    variables = {
      URL = "https://bc1yy8dzsg.execute-api.eu-west-1.amazonaws.com/v1/data"
      subnet_id = subnet.private.id
    }
  }
  filename = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
}
