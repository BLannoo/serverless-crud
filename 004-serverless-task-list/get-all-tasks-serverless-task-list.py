import json


def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
        },
        "body": json.dumps([
            {"description": "Pay Bills", "isCompleted": False},
            {"description": "Go Shopping", "isCompleted": False},
            {"description": "See the Doctor", "isCompleted": True},
        ])
    }
