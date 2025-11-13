//
//  CardModel.swift
//  BitriseBankingiOSDemo
//
//  Created by Balazs Ilsinszki on 2025. 03. 15..
//
import Combine

class AccountModel: ObservableObject, Identifiable{
    var accountID: String?
    var accountNumber: String?
    var currencyType: Currency?
    var amount: Double?
    
    init(accountID: String? = nil, currencyType: Currency? = nil, accountNumber: String? = nil, amount: Double? = nil) {
        self.accountID = accountID
        self.accountNumber = accountNumber
        self.currencyType = currencyType
        self.amount = amount
    }
    
    // Custom initializer from dictionary
    init?(json: [String: Any]) {
        guard let accountID = json["account_id"] as? String,
              let accountNumber = json["account_number"] as? String,
              let currencyType = json["currency"] as? String,
              let amount = json["balance"] as? String else {
            return nil
        }
        
        self.accountID = accountID
        self.accountNumber = accountNumber
        self.currencyType = Currency(from: currencyType)
        self.amount = Double(amount) ?? 0.0
    }
    
    var last4Digits: String? {
        guard let cardNumber = accountNumber else { return nil }
        return String(cardNumber.suffix(4))
    }
}
