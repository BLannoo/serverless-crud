## Based on
https://aws.amazon.com/getting-started/projects/data-modeling-gaming-app-with-dynamodb/


## Steps
1) Create a DynamoDB table `task-list` with primary key `PK`
2) Upload the original tasks:
    * {"PK": "TASK#32cbf8c5-f080-45f6-a616-e84b40c54c4c", "description": "Pay Bills", "isCompleted": False},
    * {"PK": "TASK#de8bf42a-1b6d-494a-ac4b-ebe0225a5774", "description": "Go Shopping", "isCompleted": False},
    * {"PK": "TASK#7aac9f6e-b959-4766-8ae1-c35d46ad956c", "description": "See the Doctor", "isCompleted": True},
3) Update [lambda](get-all-tasks-serverless-task-list.py) to retrieve your tasks from DynamoDB
    * remark: fields are dictionnaries with the type as key and the data as value
    