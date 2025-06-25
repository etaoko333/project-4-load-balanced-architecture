# Red EC2 Instance
resource "aws_instance" "red_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.website_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_s3_profile.name
  key_name               = var.key_pair_name != "" ? var.key_pair_name : null

  user_data = templatefile("${path.module}/user-data-red.sh", {
    bucket_name = aws_s3_bucket.website_bucket.id
  })

  tags = {
    Name        = "${var.project_name}-red-instance"
    Environment = var.environment
    ServerType  = "Red"
  }
}

# Blue EC2 Instance
resource "aws_instance" "blue_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[1]
  vpc_security_group_ids = [aws_security_group.website_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_s3_profile.name
  key_name               = var.key_pair_name != "" ? var.key_pair_name : null

  user_data = templatefile("${path.module}/user-data-blue.sh", {
    bucket_name = aws_s3_bucket.website_bucket.id
  })

  tags = {
    Name        = "${var.project_name}-blue-instance"
    Environment = var.environment
    ServerType  = "Blue"
  }
}
