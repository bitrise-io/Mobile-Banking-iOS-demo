from aws_cdk import (
    Stack,
    RemovalPolicy,
    aws_lambda as _lambda,
    aws_apigateway as apigw,
    aws_dynamodb as ddb
)
from constructs import Construct

class UserApiStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs):
        super().__init__(scope, construct_id, **kwargs)

        accounts_table = ddb.Table(
            self, "AccountsTable",
            partition_key=ddb.Attribute(
                name="user_id", type=ddb.AttributeType.STRING
            ),
            sort_key=ddb.Attribute(
                name="account_id", type=ddb.AttributeType.STRING
            ),
            billing_mode=ddb.BillingMode.PAY_PER_REQUEST,
            removal_policy=RemovalPolicy.DESTROY
        )

        transactions_table = ddb.Table(
            self, "TransactionsTable",
            partition_key=ddb.Attribute(
                name="user_id", type=ddb.AttributeType.STRING
            ),
            sort_key=ddb.Attribute(
                name="transaction_id", type=ddb.AttributeType.STRING
            ),
            billing_mode=ddb.BillingMode.PAY_PER_REQUEST,
            removal_policy=RemovalPolicy.DESTROY
        )

        # Lambda Function (code loaded from project root)
        fn = _lambda.Function(
            self, "UserApiFunction",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="app.lambda_handler",
            code=_lambda.Code.from_asset(
                "../",  # Make sure your app.py and models/utils are here
                exclude=["cdk", "cdk.out", ".venv", "__pycache__", ".git"]
            ),
            environment={
                "ACCOUNTS_TABLE": accounts_table.table_name,
                "TRANSACTIONS_TABLE": transactions_table.table_name
            }
        )

        # Grant permissions to the Lambda function
        accounts_table.grant_read_write_data(fn)
        transactions_table.grant_read_write_data(fn)

        # API Gateway with routes
        api = apigw.RestApi(self, "UserApi")

        users = api.root.add_resource("users")
        user_id = users.add_resource("{userId}")
        user_accounts = user_id.add_resource("accounts")
        user_transactions = user_id.add_resource("transactions")

        user_accounts.add_method("GET", apigw.LambdaIntegration(fn))
        user_accounts.add_method("POST", apigw.LambdaIntegration(fn))
        user_transactions.add_method("GET", apigw.LambdaIntegration(fn))
        user_transactions.add_method("POST", apigw.LambdaIntegration(fn))
