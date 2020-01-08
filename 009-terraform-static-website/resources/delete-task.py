import json
import boto3
import os

dynamodb = boto3.client('dynamodb')


def lambda_handler(event, context):
    data = json.loads(event['body'])
    dynamodb.delete_item(
        TableName=os.environ['tableName'],
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
