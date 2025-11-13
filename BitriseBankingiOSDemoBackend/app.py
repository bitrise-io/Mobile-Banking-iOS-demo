import json
import os
import boto3
from boto3.dynamodb.conditions import Key
from decimal import Decimal
from dataclasses import asdict

from models import Account, Transaction
from utils import generate_uuid, generate_account_number, current_timestamp, default_balance

dynamodb = boto3.resource("dynamodb")
accounts_table = dynamodb.Table(os.environ["ACCOUNTS_TABLE"])
transactions_table = dynamodb.Table(os.environ["TRANSACTIONS_TABLE"])

def lambda_handler(event, context):
    method = event["httpMethod"]
    path = event["path"]
    user_id = event["pathParameters"]["userId"]

    if method == "GET" and path.endswith("/accounts"):
        return get_accounts(user_id)

    elif method == "POST" and path.endswith("/accounts"):
        try:
            body = json.loads(event.get("body", "{}"))
        except json.JSONDecodeError:
            return response({"error": "Invalid JSON"}, status=400)
        return create_account(user_id, body)

    elif method == "GET" and path.endswith("/transactions"):
        return get_transactions(user_id)

    elif method == "POST" and path.endswith("/transactions"):
        try:
            body = json.loads(event.get("body", "{}"))
        except json.JSONDecodeError:
            return response({"error": "Invalid JSON"}, status=400)
        return create_transaction(user_id, body)

    return response({"error": "Not Found"}, status=404)

def get_accounts(user_id):
    result = accounts_table.query(
        KeyConditionExpression=Key("user_id").eq(user_id)
    )
    return response(result["Items"])

def create_account(user_id, body):
    if "currency" not in body:
        return response({"error": "Missing 'currency'"}, status=400)

    acc = Account(
        user_id=user_id,
        account_id=generate_uuid(),
        account_number=generate_account_number(),
        currency=body["currency"],
        balance=Decimal(str(default_balance()))
    )
    accounts_table.put_item(Item=asdict(acc))
    return response(asdict(acc), status=201)

def get_transactions(user_id):
    result = transactions_table.query(
        KeyConditionExpression=Key("user_id").eq(user_id)
    )
    return response(result["Items"])

def create_transaction(user_id, body):
    required_fields = ["from_account_id", "to_account_id", "amount", "currency"]
    missing = [f for f in required_fields if f not in body]
    if missing:
        return response({"error": f"Missing fields: {', '.join(missing)}"}, status=400)

    tx = Transaction(
        user_id=user_id,
        transaction_id=generate_uuid(),
        from_account_id=body["from_account_id"],
        to_account_id=body["to_account_id"],
        amount=Decimal(str(body["amount"])),
        currency=body["currency"],
        description=body.get("description", ""),
        date=current_timestamp()
    )
    transactions_table.put_item(Item=asdict(tx))
    return response(asdict(tx), status=201)

def response(body, status=200):
    return {
        "statusCode": status,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(body, default=decimal_encoder)
    }

def decimal_encoder(obj):
    if isinstance(obj, Decimal):
        return str(obj)
    raise TypeError(f"Object of type {type(obj)} is not JSON serializable")
