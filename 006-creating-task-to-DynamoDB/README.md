## Using
* https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/send
* https://www.npmjs.com/package/uuid#quickstart---browser-ready-versions

## steps
1) Let the data go to a lambda
    1) Create a lambda function for your backend: `create-task-serverless-task-list`
        * With the existing IAM Role: `serverless-task-list-role`
        * Based on this [script](create-task-serverless-task-list.py)
        * add 'tableName' as an environment variable with value 'task-list'
    2) Add API Gateway as trigger: (default name: `get-all-tasks-serverless-task-list-API`)
        * This can be done from the AWS::Lambda service
        * Security: Open (TODO: add security)
    3) recreate your API-Gateway-method as 'POST' instead of 'ANY'
        * select: Use Lambda Proxy integration
    4) (optional) create 'OPTIONS' (preflight request) API-Gateway-method using: Actions -> Enable CORS
        * TODO: investigate what is created by Enable-CORS-action (described while running it)
        * Not necessary for POST without any extra headers 
    5) Deploy your API
    6) Adapt your index.html with: `<script src="http://wzrd.in/standalone/uuid%2Fv4@latest"></script>` and
    ```javascript
        const postXhttp = new XMLHttpRequest();
        postXhttp.open("POST", "https://wtka97jyek.execute-api.eu-west-1.amazonaws.com/default/create-task-serverless-task-list", true);
        postXhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        postXhttp.send(JSON.stringify({
            "PK": uuidv4(),
            "description": document.getElementById("new-task").value,
            "isCompleted": false
        }));
    ```
    