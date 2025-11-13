#!/usr/bin/env python3
import aws_cdk as cdk
from user_api_stack import UserApiStack

app = cdk.App()

UserApiStack(
    app, 
    "UserApiStack",
    env=cdk.Environment(
        account="792115950017",
        region="eu-central-1"
    )
)

app.synth()
