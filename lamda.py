# python lambda function that makes request remote API endpoint and returns the response
import requests
import json

def lambda_handler(event, context):
    url = "https://bc1yy8dzsg.execute-api.eu-west-1.amazonaws.com/v1/data"
    response = requests.get(url)
    data = response.json()
    if response.status_code != 200:
        return {
            'statusCode': response.status_code,
            'body': json.dumps(data)
        }
    else:
        return {
        'statusCode': 200,
        'body': json.dumps(data)
       }


