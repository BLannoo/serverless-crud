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
    2) Add API Gateway as trigger: (not the default name, but: `console-crud-experiment-API`)
        * This can be done from the AWS::Lambda service
        * Security: Open (TODO: add security)
    3) recreate your API-Gateway-method as 'GET' instead of 'ANY'
        * select: Use Lambda Proxy integration
    4) Deploy your API
    5) Adapt index.html to call you lambda (fill in your api-gateway-id in XXXXXXXXXX)
    ```javascript
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                let tasks = JSON.parse(this.response);
                for (let i = 0; i < tasks.length; i++)
                    renderTaskElement(tasks[i].description, tasks[i].isCompleted)
            }
        };
        xhttp.open("GET", "https://XXXXXXXXXX.execute-api.eu-west-1.amazonaws.com/default/console-crud-experiment-get-tasks", true);
        xhttp.send();
    ```
3) Setup a lambda + update api-gateway for pushing data to DynamoDB
    1) Create a lambda function for your backend: `console-crud-experiment-create-task`
        * With the existing IAM Role: `console-crud-experiment-role`
        * Based on this [script](create-task.py)
        * add 'tableName' as an environment variable with value 'console-crud-experiment-db'
    2) Add API Gateway as trigger: (default name: `console-crud-experiment-API`)
        * This can be done from the AWS::Lambda service
        * Security: Open (TODO: add security)
    3) recreate your API-Gateway-method as 'POST' instead of 'ANY'
        * select: Use Lambda Proxy integration
    4) (optional) create 'OPTIONS' (preflight request) API-Gateway-method using: Actions -> Enable CORS
        * Not necessary for POST without any extra headers 
    5) Deploy your API
    6) Adapt your index.html with: 
    `<script src="http://wzrd.in/standalone/uuid%2Fv4@latest"></script>` 
    and (fill in your api-gateway-id in XXXXXXXXXX)
    ```javascript
        const postXhttp = new XMLHttpRequest();
        postXhttp.open("POST", "https://XXXXXXXXXX.execute-api.eu-west-1.amazonaws.com/default/console-crud-experiment-create-task", true);
        postXhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        postXhttp.send(JSON.stringify({
            "PK": uuidv4(),
            "description": document.getElementById("new-task").value,
            "isCompleted": false
        }));
    ```
4) Enable updates reusing the create endpoint
    1) Adapt your index.html with (fill in your api-gateway-id in XXXXXXXXXX)
    ```javascript
        let isCompleted = this.parentNode.querySelector('input[type="checkbox"]').checked;
        let updatedTask = {
            "PK": this.parentNode.id,
            "description": this.parentNode.textContent.substr(1), // substr(1) to remove the X from the delete button
            "isCompleted": isCompleted
        };
        const postXhttp = new XMLHttpRequest();
        postXhttp.open("POST", "https://XXXXXXXXXX.execute-api.eu-west-1.amazonaws.com/default/console-crud-experiment-create-task", true);
        postXhttp.send(JSON.stringify(updatedTask));
    ```

## Generated resources (to delete to undo this setup):
* S3::Bucket: `console-crud-experiment-db`
* Lambda: `console-crud-experiment-get-all-tasks` and `console-crud-experiment-create-task`
* IAM::Role: `console-crud-experiment-role`
* API-Gateway: `console-crud-experiment-API`
* DynamoDB: `console-crud-experiment-db`