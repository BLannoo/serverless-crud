import boto3
import json

dynamodb = boto3.client('dynamodb')


def lambda_handler(event, context):
    response = dynamodb.scan(TableName='task-list')
    tasks = list(
        {
            'PK': item['PK']['S'],
            'description': item['description']['S'],
            'isCompleted': item['isCompleted']['BOOL'],
        }
        for item in response['Items']
    )
    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
        },
        "body": json.dumps(tasks)
    }
