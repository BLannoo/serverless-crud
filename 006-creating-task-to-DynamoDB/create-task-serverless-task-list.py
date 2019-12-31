import json
import boto3

dynamodb = boto3.client('dynamodb')


def lambda_handler(event, context):
    data = json.loads(event['body'])
    dynamodb.put_item(
        TableName='task-list',
        Item={
            'PK': {'S': data['PK']},
            'description': {'S': data['description']},
            'isCompleted': {'BOOL': data['isCompleted']}
        })
    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
        },
        "body": "done"
    }
