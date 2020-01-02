import json
import boto3

dynamodb = boto3.client('dynamodb')


def lambda_handler(event, context):
    data = json.loads(event['body'])
    dynamodb.delete_item(
        TableName='task-list',
        Key={
            'PK': {'S': data['PK']}
        }
    )
    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
        },
        "body": "done"
    }
