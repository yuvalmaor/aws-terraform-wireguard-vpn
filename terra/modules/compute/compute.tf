resource "aws_instance" "terraform_instance" {
  ami           = "ami-007020fd9c84e18c7"  // Example AMI ID for Amazon Linux in ap-south-1
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_terraform_profile.name
  key_name = "yuvalaws_key"
  user_data =  file("install_docker_terra_ubuntu.sh")
  subnet_id =  var.subnets_id[0]
  #vpc_security_group_ids = var.instance_sg
  vpc_security_group_ids = [var.instance_sg.id]

  tags = {
    Name = "TerraformEC2InstanceYUVAL"
    Owner = "yuval.maor"
    expiration_date = "30-04-2024"
    bootcamp = "20"
  }
}


resource "aws_iam_instance_profile" "ec2_terraform_profile" {
  name = "ec2_terraform_profile"
  role = aws_iam_role.ec2_terraform_role.name
}

resource "aws_iam_role" "ec2_terraform_role" {
  name = "ec2_terraform_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy" "ec2_terraform_policy" {
  name = "ec2_terraform_policy"
  role = aws_iam_role.ec2_terraform_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
          "iam:*",
          "s3:*",
          "elasticloadbalancing:*",
          "SNS:*",
          "autoscaling:*",
          "cloudwatch:*",
          "eks:*",
          "dynamodb:*",
          // Add other permissions as neededdestroy
        ]
        Resource = "*"
        Effect = "Allow"
      },
      {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "arn:aws:iam::644435390668:role/eks-cluster-role-*",
      "Condition": {
        "StringLike": {
          "iam:PassedToService": "eks.amazonaws.com"
        }
      }
    }
    ]
  })
}