provider "aws" {
region = "us-east-1"
profile = "prod"
}


/*
resource "aws_iam_role" "test_role" {
  name = "test_role-name"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [ "sts:TagSession", "sts:AssumeRole" ],
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Resource = "arn:aws:iam::366751107728:role/allow-s3-readonly-access-from-other-accounts"
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

*/


resource "aws_iam_policy" "policy" {
  name        = var.policy-name
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Sid = "",
            Effect =  "Allow",
            Action = [
             "sts:TagSession", "sts:AssumeRole" ],
            Resource =  "arn:aws:iam::366751107728:role/non-prod-role"

                    
                
            
        }
    ]
})
}

resource "aws_iam_policy" "self-mgmt-policy" {
  name        = var.self-mgmt-policy
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Sid = "iamUserSelfManagement",
            Effect =  "Allow",
            Action = [
                "iam:UploadSigningCertificate",
                "iam:UploadSSHPublicKey",
                "iam:UpdateUser",
                "iam:UpdateSSHPublicKey",
                "iam:UpdateLoginProfile",
                "iam:UpdateAccessKey",
                "iam:ResyncMFADevice",
                "iam:List*",
                "iam:Get*",
                "iam:GenerateServiceLastAccessedDetails",
                "iam:GenerateCredentialReport",
                "iam:DeleteVirtualMFADevice",
                "iam:DeleteSSHPublicKey",
                "iam:DeleteLoginProfile",
                "iam:DeleteAccessKey",
                "iam:DeactivateMFADevice",
                "iam:CreateLoginProfile",
                "iam:CreateAccessKey",
                "iam:ChangePassword",
                "iam:GetAccountSummary",
                "iam:ListAccessKeys",
              
],         
            Resource =  [ "arn:aws:iam::641656137676:user/$${aws:username}",
                          "arn:aws:iam::641656137676:mfa/$${aws:username}"
                        ],
            Condition = {
              "Bool": {
                    "aws:MultiFactorAuthPresent": [
                        "true"
                    ]
                }
}        



 }, 

{
            Sid = "IamUserSelfManagementPermissionsThatDontRequireMFA",
            Effect =  "Allow",
            Action = [
                "iam:ListMFADevices",
                "iam:GetUser",
                "iam:EnableMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:CreateVirtualMFADevice",
                "iam:ListAccessKeys"
                
],

            Resource =  [ "arn:aws:iam::641656137676:user/$${aws:username}",
                "arn:aws:iam::641656137676:mfa/$${aws:username}"  ],
                },
            {
            Sid = "MoreIamUserSelfManagementPermissionsThatDontRequireMFA",
            Effect = "Allow",
            Action = [
                "iam:ListVirtualMFADevices",
                "iam:ListUsers",
                "iam:ListMFADevices",
                "iam:GetUser",
                "iam:EnableMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:CreateVirtualMFADevice"
            ],
            "Resource": "*"
        },

         {
            "Sid": "iamUserSelfManagementSupport",
            "Effect": "Allow",
            "Action": [
                "iam:ListPolicyVersions",
                "iam:ListGroups",
                "iam:ListGroupPolicies",
                "iam:ListEntitiesForPolicy",
                "iam:ListAttachedGroupPolicies",
                "iam:GetServiceLastAccessedDetails",
                "iam:GetPolicyVersion",
                "iam:GetPolicy",
                "iam:GetGroupPolicy",
                "iam:GetAccountPasswordPolicy"
            ],
            Resource = "*",
            "Condition": {
                "Bool": {
                    "aws:MultiFactorAuthPresent": [
                        "true"
                    ]
                }
            }
        },
         {
            Sid = "listAllIamUsers",
            Effect = "Allow",
            Action = "iam:ListUsers",
            Resource = "*",
            "Condition": {
                "Bool": {
                    "aws:MultiFactorAuthPresent": [
                        "true"
                    ]
                }
            }
        }




]
})

}




resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policy.arn
}


resource "aws_iam_user_policy_attachment" "test-attachment" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.self-mgmt-policy.arn
}
resource "aws_iam_user" "user" {
  name = var.user-name
  force_destroy = "true"
}

resource "aws_iam_user_login_profile" "example" {
  user    = aws_iam_user.user.name
  pgp_key = "keybase:rohanshahi"
  #force_destroy = "true"
}

output "encrypted_password" {
  value = aws_iam_user_login_profile.example.encrypted_password
}

output "password" {
  value = aws_iam_user_login_profile.example.password
}