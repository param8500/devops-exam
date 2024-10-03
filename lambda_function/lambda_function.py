# python lambda function that makes request remote API endpoint and returns the response
import requests
import json
import os

def lambda_handler(event, context):
    url = os.environ['URL']
    headers = {
        'X-Siemens-Auth': 'test',
    }
    payload = {
        "subnet_id": os.environ['subnet_id'],
        "name": "Addala Paramasiva",
        "email": "addalaparamasiva55@gmail.com"
    }
    response = requests.get(url, headers=headers, data=json.dumps(payload))
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


