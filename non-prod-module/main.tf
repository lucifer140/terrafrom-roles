# provider "aws" {
# region = "us-west-2"
# profile = "nonprod"
# }







resource "aws_iam_policy" "non-prod-mgmt" {
  name        = var.non-prod-mgmt-policy
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            #Sid = "iamUserSelfManagement",
            #Effect =  "Allow",
            Action = [
                "s3:*",
                "synthetics:*",
                "cloudwatch:*",
                "redshift:DescribeClusters",
                "redshift:ViewQueriesInConsole",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:DescribeInternetGateways",
                "sns:Get*",
                "sns:List*",
                "cloudwatch:Describe*",
                "cloudwatch:List*",
                "cloudwatch:Get*",
                "kms:DescribeKey",
                "kms:ListAliases",
                "secretsmanager:CreateSecret",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DeleteSecret",
                "secretsmanager:TagResource",
                "sqlworkbench:*",
                "tag:Get*",
                "tag:GetResources"
],         
            Effect = "Allow",
                    Resource = "*"
        }
    ]
})

}


resource "aws_iam_role" "non-prod-test-role" {
  name        = var.non-prod-test-role
  path        = "/"
  description = "My test role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect =  "Allow",
            Principal = {
                "AWS": "arn:aws:iam::641656137676:root"
            },
            Action =  "sts:AssumeRole" ,
            Condition = {
                Bool = {
                    "aws:MultiFactorAuthPresent": "true"
                }
            }

                    
                
            
        }
    ]
})
}

/*
resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policy.arn
}
*/


/*
resource "aws_iam_role" "non-prod-role" {
  name               = var.non-prod-role
  path               = "/system/"
  assume_role_policy = aws_iam_policy.non-prod-mgmt.policy_arn
}
*/




resource "aws_iam_policy_attachment" "test-attach" {
  name       = "role-attachment"
  #users      = [aws_iam_user.user.name]
  roles      = [aws_iam_role.non-prod-test-role.name]
  #groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.non-prod-mgmt.arn
}