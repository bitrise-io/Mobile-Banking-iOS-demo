//
//  TransactionModel.swift
//  BitriseBankingiOSDemo
//
//  Created by Balazs Ilsinszki on 2025. 03. 24..
//

import Combine

class TransactionModel: ObservableObject, Identifiable{
    var currencyType: Currency?
    var cardNumber: String?
    var amount: Double?
    
    init(currencyType: Currency? = nil) {
        self.currencyType = currencyType
    }
}
