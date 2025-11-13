//
//  DemoAccount.swift
//  BitriseBankingiOSDemo
//
//  Created by Szabolcs Toth on 2025. 10. 14..
//

import Foundation

struct DemoAccount {
    let email: String
    let amount: Double
    let currency: Currency
    let transactions: [DemoTransaction]
}
    
struct DemoTransaction: Identifiable {
    let id = UUID()
    let date: String
    let name: String
    let amount: Double
    let type: TransactionType
}

enum TransactionType {
    case sent
    case received
}
