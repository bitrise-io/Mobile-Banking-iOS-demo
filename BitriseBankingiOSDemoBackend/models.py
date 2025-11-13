from dataclasses import dataclass
from typing import Optional
from decimal import Decimal

@dataclass
class Account:
    user_id: str
    account_id: str
    account_number: str
    currency: str
    balance: Decimal = Decimal("1000.0")

@dataclass
class Transaction:
    user_id: str
    transaction_id: str
    from_account_id: str
    to_account_id: str
    amount: Decimal
    currency: str
    description: Optional[str]
    date: str
    status: str = "SUCCESS"
    is_user_initiated: bool = True
