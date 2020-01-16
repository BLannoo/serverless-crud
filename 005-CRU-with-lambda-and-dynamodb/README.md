## Based on
* 004-s3-hosting
* 001-my-first-serverless-webpage steps 4-6, 8-9
* https://aws.amazon.com/getting-started/projects/data-modeling-gaming-app-with-dynamodb/
* https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/send
* https://www.npmjs.com/package/uuid#quickstart---browser-ready-versions


## Steps
1) Setup DynamoDB
    1) Create a DynamoDB table `console-crud-experiment-db` with primary key `PK`
    2) Upload the original tasks:
        { "PK": {"S": "TASK#32cbf8c5-f080-45f6-a616-e84b40c54c4c"}, "description": {"S": "Pay Bills"}, "isCompleted": {"BOOL": false} }
        { "PK": {"S": "TASK#de8bf42a-1b6d-494a-ac4b-ebe0225a5774"}, "description": {"S": "Go Shopping"}, "isCompleted": {"BOOL": false} }
        { "PK": {"S": "TASK#7aac9f6e-b959-4766-8ae1-c35d46ad956c"}, "description": {"S": "See the Doctor"}, "isCompleted": {"BOOL": true} }
2) Setup a lambda + api-gateway for retrieving data from DynamoDB
    1) Create a lambda function for your backend: `console-crud-experiment-get-all-tasks`
        * With a new IAM Role: `console-crud-experiment-role`
            * Based on the Policy template: `Simple microservice permissions`
        * Based on this [script](get-all-tasks.py)
        * add 'tableName' as an environment variable with value 'console-crud-experiment-db'
    2) Create an API Gateway: (REST API), API name: `console-crud-experiment-API`
    3) Add a resource to your API Gateway: Actions > Create Resource: Resource Name: `get-all-tasks`
        * With a method: Actions > Create Method: GET
            * Use Lambda Proxy integration: true
            * Lambda Function: `console-crud-experiment-get-all-tasks`
    4) Deploy your API: Actions > Deploy API: Deployment stage: [New Stage], Stage name: default
    5) Adapt index.html to call you lambda (fill in your api-gateway-id in XXXXXXXXXX)
3) Setup a lambda + update api-gateway for pushing data to DynamoDB
    1) Create a lambda function for your backend: `console-crud-experiment-create-task`
        * With the existing IAM Role: `console-crud-experiment-role`
        * Based on this [script](create-task.py)
        * add 'tableName' as an environment variable with value `console-crud-experiment-db`
    2) Add a resource to your API Gateway: Actions > Create Resource: Resource Name: `create-task`
        * With a method: Actions > Create Method: POST
            * Use Lambda Proxy integration: true
            * Lambda Function: `console-crud-experiment-create-task`
    4) Deploy your API: Actions > Deploy API: Deployment stage: default
    5) Adapt index.html to call you lambda (fill in your api-gateway-id in XXXXXXXXXX)
4) Enable updates reusing the create endpoint
    1) Adapt your index.html with (fill in your api-gateway-id in XXXXXXXXXX)

## Generated resources (to delete to undo this setup):
* S3::Bucket: `console-crud-experiment-db`
* Lambda: `console-crud-experiment-get-all-tasks` and `console-crud-experiment-create-task`
* IAM::Role: `console-crud-experiment-role`
* API-Gateway: `console-crud-experiment-API`
* DynamoDB: `console-crud-experiment-db`