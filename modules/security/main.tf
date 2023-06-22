#`````````
#IAM role for frontend instances to read load balancer's DNS
#`````````
#Role to assume role
resource "aws_iam_role" "frontend_read" {
  name = "frontend-read"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" = "sts:AssumeRole",
        "Principal" = {
          "Service" = "ec2.amazonaws.com"
        },
        "Effect" = "Allow"
      }
    ]
  })
}
#assign instance profile
resource "aws_iam_instance_profile" "frontend_iam_profile" {
  name = "frontend-iam-profile"
  role = aws_iam_role.frontend_read.name
}
#load balancer read permissions
resource "aws_iam_role_policy" "frontend_iam_policy" {
  name = "frontend-iam-policy"
  role = aws_iam_role.frontend_read.name
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect" : "Allow",
        "Action" : "elasticloadbalancing:Describe*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeInstances",
          "ec2:DescribeClassicLinkInstances",
          "ec2:DescribeSecurityGroups"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "arc-zonal-shift:GetManagedResource",
        "Resource" : "arn:aws:elasticloadbalancing:*:*:loadbalancer/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "arc-zonal-shift:ListManagedResources",
          "arc-zonal-shift:ListZonalShifts"
        ],
        "Resource" : "*"
      }
    ]
  })
}
#`````````
#IAM role for backend instances to read from RDS
#`````````
#role to assume role
resource "aws_iam_role" "backend_read" {
  name = "BackendRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" = "sts:AssumeRole",
        "Principal" = {
          "Service" = "ec2.amazonaws.com"
        },
        "Effect" = "Allow"
      }
    ]
  })
}
#assign instance profile
resource "aws_iam_instance_profile" "backend_iam_profile" {
  name = "backend-iam-profile"
  role = aws_iam_role.backend_read.name
}
#lambda read permissions
resource "aws_iam_role_policy" "backend_iam_policy" {
  name = "backend-iam-policy"
  role = aws_iam_role.backend_read.name
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:CreateNetworkInterface",
                "ec2:AttachNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "autoscaling:CompleteLifecycleAction",
                "ec2:DeleteNetworkInterface"
            ]
        },
      {
            "Effect": "Allow",
            "Action": "rds-db:*",
            "Resource": "arn:aws:rds-db:us-east-1:706005972653:dbuser:*/webapp"
        },
      {
            "Effect": "Allow",
            "Action": [
                "rds:Describe*",
                "rds:ListTagsForResource",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcs"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3-object-lambda:Get*",
                "s3-object-lambda:List*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
  })
}
#`````````
#IAM role for NAT instances to get VPC CIDR block
#`````````
#Role to assume role
resource "aws_iam_role" "nat_read" {
  name = "nat-read"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" = "sts:AssumeRole",
        "Principal" = {
          "Service" = "ec2.amazonaws.com"
        },
        "Effect" = "Allow"
      }
    ]
  })
}
#assign instance profile
resource "aws_iam_instance_profile" "nat_iam_profile" {
  name = "nat-iam-profile"
  role = aws_iam_role.nat_read.name
}
#vpc read permissions
resource "aws_iam_role_policy" "nat_iam_policy" {
  name = "nat-iam-policy"
  role = aws_iam_role.nat_read.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeCarrierGateways",
                "ec2:DescribeClassicLinkInstances",
                "ec2:DescribeCustomerGateways",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeEgressOnlyInternetGateways",
                "ec2:DescribeFlowLogs",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeLocalGatewayRouteTables",
                "ec2:DescribeLocalGatewayRouteTableVpcAssociations",
                "ec2:DescribeMovingAddresses",
                "ec2:DescribeNatGateways",
                "ec2:DescribeNetworkAcls",
                "ec2:DescribeNetworkInterfaceAttribute",
                "ec2:DescribeNetworkInterfacePermissions",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribePrefixLists",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroupReferences",
                "ec2:DescribeSecurityGroupRules",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeStaleSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcClassicLink",
                "ec2:DescribeVpcClassicLinkDnsSupport",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeVpcEndpointConnectionNotifications",
                "ec2:DescribeVpcEndpointConnections",
                "ec2:DescribeVpcEndpointServiceConfigurations",
                "ec2:DescribeVpcEndpointServicePermissions",
                "ec2:DescribeVpcEndpointServices",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeVpcs",
                "ec2:DescribeVpnConnections",
                "ec2:DescribeVpnGateways"
            ],
            "Resource": "*"
        }
    ]
})
}
#``````````
#NAT instance security group
#``````````
resource "aws_security_group" "nat_sg" {
  name = "NAT-SG"
  description = "Security group for the NAT instance"
  
  ingress {
    description = "Ingress CIDR"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.vpc_cidr_block]
    self = true
  }

  egress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
}
#``````````
#Frontend security group
#``````````
resource "aws_security_group" "frontend_sg" {
  name        = "Frontend-SG"
  description = "Allow traffic to frontend LB"
  ingress {
    description = "Traffic to LB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from home pc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  #have to specify egress rule since terraform doesn't do it
  egress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
}
#``````````
#Backend security group
#``````````
resource "aws_security_group" "backend_sg" {
  name        = "Backend-SG"
  description = "Backend security group"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }
  #have to specify egress rule since terraform doesn't do it
  egress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#```````````
#DB security group
#```````````
resource "aws_security_group" "database_sg" {
  name        = "Database-SG"
  description = "Database security group"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  ingress {
    description = "postgreSQL from home pc"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  #have to specify egress rule since terraform doesn't do it
  egress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#```````````
#Lambda IAM Role
#```````````
#role to assume role
resource "aws_iam_role" "lambda_read" {
  name = "LambdaRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" = "sts:AssumeRole",
        "Principal" = {
          "Service" = "lambda.amazonaws.com"
        },
        "Effect" = "Allow"
      }
    ]
  })
}
#assign instance profile
resource "aws_iam_instance_profile" "lambda_iam_profile" {
  name = "lambda-iam-profile"
  role = aws_iam_role.lambda_read.name
}
#lambda read permissions
resource "aws_iam_role_policy" "lambda_iam_policy" {
  name = "lambda-iam-policy"
  role = aws_iam_role.lambda_read.name
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:CreateNetworkInterface",
                "ec2:AttachNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "autoscaling:CompleteLifecycleAction",
                "ec2:DeleteNetworkInterface"
            ]
        },
      {
            "Effect": "Allow",
            "Action": "rds-db:*",
            "Resource": "arn:aws:rds-db:us-east-1:706005972653:dbuser:*/lambda"
        },
      {
            "Effect": "Allow",
            "Action": [
                "rds:Describe*",
                "rds:ListTagsForResource",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcs"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricData",
                "logs:DescribeLogStreams",
                "logs:GetLogEvents",
                "devops-guru:GetResourceCollection"
            ],
            "Resource": "*"
        },
        {
            "Action": [
                "devops-guru:SearchInsights",
                "devops-guru:ListAnomaliesForInsight"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "ForAllValues:StringEquals": {
                    "devops-guru:ServiceNames": [
                        "RDS"
                    ]
                },
                "Null": {
                    "devops-guru:ServiceNames": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3-object-lambda:Get*",
                "s3-object-lambda:List*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
  })
}