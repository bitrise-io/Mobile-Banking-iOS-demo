# 🚀 Serverless User Accounts & Transactions API (CDK + Lambda + DynamoDB)

This project sets up a fully serverless REST API using:

- **API Gateway** to expose HTTP endpoints  
- **AWS Lambda (Python 3.12)** to handle backend logic  
- **DynamoDB** for persistent data storage  
- **AWS CDK (Python)** for defining infrastructure as code  

---

## 📁 Project Structure

```
user-api/
├── app.py                # Lambda entry point
├── models.py             # Account and transaction models
├── utils.py              # Utility functions
├── requirements.txt      # Lambda function dependencies
├── cdk/
│   ├── __init__.py
│   ├── app.py            # CDK app entry
│   └── user_api_stack.py # Stack definition for API + Lambda + DynamoDB
```

---

## ✅ Prerequisites

- Python 3.10 or higher
- Node.js and npm
- AWS CLI configured with appropriate credentials
- AWS CDK installed globally:

```bash
npm install -g aws-cdk
```

---

## 🛠️ Setup

### 1. Install Lambda dependencies

From the project root:

```bash
pip3 install -r requirements.txt
```

Also make sure the cdk/app.py file contains the right AWS account number, region. 

### 2. Bootstrap your AWS environment (only needed once per account/region)

```bash
cdk bootstrap
```

---

## 🚀 Deploy the API Stack

Run from the `cdk/` directory:

```bash
pip3 install aws-cdk-lib constructs
```

For deployments run:
```bash
cdk deploy
```

Once deployed, you’ll get an API endpoint like:

```
https://<api-id>.execute-api.<region>.amazonaws.com/prod
```

---

## 🧪 Try It Out

Assume your user ID is `user123`.

### ➕ Create an Account

```bash
curl -X POST https://<api-id>.execute-api.<region>.amazonaws.com/prod/users/user123/accounts \
  -H "Content-Type: application/json" \
  -d '{"currency": "USD"}'
```

### 📄 Get All Accounts

```bash
curl https://<api-id>.execute-api.<region>.amazonaws.com/prod/users/user123/accounts
```

### 💸 Create a Transaction

```bash
curl -X POST https://<api-id>.execute-api.<region>.amazonaws.com/prod/users/user123/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "from_account_id": "abc123",
    "to_account_id": "xyz789",
    "amount": 250.50,
    "currency": "USD",
    "description": "Payment for invoice #45"
}'
```

### 📄 Get All Transactions

```bash
curl https://<api-id>.execute-api.<region>.amazonaws.com/prod/users/user123/transactions
```

---

## 🧼 Cleanup Resources

To tear down all deployed infrastructure:

```bash
cdk destroy
```
