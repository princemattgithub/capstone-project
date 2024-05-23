{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "ecs:*",
              "ecr:*",
              "ec2:*",
              "elasticloadbalancing:*",
              "iam:PassRole"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "iam:GetRole",
              "iam:CreateServiceLinkedRole"
          ],
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "iam:AWSServiceName": [
                      "ecs.amazonaws.com",
                      "elasticloadbalancing.amazonaws.com"
                  ]
              }
          }
      }
  ]
}