## based on
* 001-my-first-serverless-webpage
* 003-task-list-webpage/index.html

## steps
1) Make the html available from S3
    1) Create a bucket: `serverless-task-list`
    2) Put your index.html, error.html and favicon.ico in S3
    3) Enable this bucket for: static website hosting
    4) Make your S3 bucket and the resources inside it public
2) Let the data come from a lambda
    1) Create a lambda function for your backend: `get-all-tasks-serverless-task-list`
        * With a new IAM Role: `serverless-task-list-role`
            * Based on the Policy template: `Simple microservice permissions`
        * Based on this [script](get-all-tasks-serverless-task-list.py)
    2) Add API Gateway as trigger: (default name: `get-all-tasks-serverless-task-list-API`)
        * This can be done from the AWS::Lambda service
        * Security: Open (TODO: add security)
    3) recreate your API-Gateway-method as 'GET' instead of 'ANY'
        * select: Use Lambda Proxy integration
    3) Deploy your API
    4) Adapt index.html to call you lambda
    ```javascript
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                let tasks = JSON.parse(this.response);
                for (let i = 0; i < tasks.length; i++)
                    renderTaskElement(tasks[i].description, tasks[i].isCompleted)
            }
        };
        xhttp.open("GET", "https://wtka97jyek.execute-api.eu-west-1.amazonaws.com/default/get-all-tasks-serverless-task-list", true);
        xhttp.send();
    ```

## Generated resources (to delete to undo this setup):
* S3::Bucket: `serverless-task-list`
* Lambda: `get-all-tasks-serverless-task-list`
* IAM::Role: `serverless-task-list-role`
* API-Gateway: `get-all-tasks-serverless-task-list-API`