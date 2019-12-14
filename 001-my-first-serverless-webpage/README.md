## based on
* Udemy: AWS Certified Developer - Associate 2020
* Lecture 36: Build a Simple Serverless Website with Route 53, API Gateway, Lambda and S3
https://www.udemy.com/course/aws-certified-developer-associate/learn/lecture/2442592#overview

## steps
1) Create a bucket: `brunos-dashboard`
2) Enable this bucket for: static website hosting
3) Could Setup DNS now: Route53 (but not free)
4) Create a lambda function for your backend: `brunos-dashboard-backend`
    * With a new IAM Role: `brunos-dashboard-backend-role`
        * Based on the Policy template: `Simple microservice permissions`
```python
def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
        },
        "body": "Bruno Lannoo"
    }
```
5) Add API Gateway as trigger: `brunos-dashboard-backend-API`
    * This can be done from the AWS::Lambda service
    * Security: Open (TODO: add security)
6) Deploy your API
7) Make your S3 bucket public
8) Adapt index.html to call you lambda
9) Put your index.html and error.html in S3

## Generated resources (to delete to undo this setup):
* S3::Bucket: `brunos-dashboard`
* Lambda: `brunos-dashboard-backend`
* IAM::Role: `brunos-dashboard-backend-role`
* API-Gateway: `brunos-dashboard-backend-API`