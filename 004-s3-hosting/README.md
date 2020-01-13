## based on
* 001-my-first-serverless-webpage step 1-2, 7, 9
* 003-task-list-webpage/index.html


## steps
1) Create a bucket: `console-crud-experiment-bucket`
2) Make bucket public:
```json
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "AllowPublicRead",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::console-crud-experiment-bucket/*"
        }
    ]
}
```
2) Put your index.html, error.html and favicon.ico in S3
3) Enable this bucket for: static website hosting

## Generated resources (to delete to undo this setup):
* S3::Bucket: `console-crud-experiment-db-bucket`