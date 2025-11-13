//
//  MainViewModel.swift
//  BitriseBankingiOSDemo
//
//  Created by Balazs Ilsinszki on 2025. 03. 15..
//

import Foundation

@MainActor
class MainViewModel: ObservableObject {
    
    @Published var isLoggedIn = false
    var userID = "user123"
    @Published var email = ""
    
    @Published var accountModels: Array<AccountModel>?
    
    init() {
        //self.cardModels = ModelProvider.getCardModels()
    }
    
    
    func login () {
        isLoggedIn = true
    }
    
    func logout () {
        isLoggedIn = false
    }
    
    func addAccount (currency: Currency) {
        Task {
            await ModelProvider.addAccount(userID: self.userID, currency: currency)
            
            Task { @MainActor in
                // Async task on main thread
                await self.refreshCards()
            }
        }
    }
    
    func refreshCards () async {
        self.accountModels = await ModelProvider.getAccountModels(userID: self.userID)
    }
    
    func currentAccount() -> DemoAccount {
        return .init(
            email: email,
            amount: 4234.59,
            currency: .eur,
            transactions: [
                .init(date: "Oct 12", name: "Acme, Inc", amount: 3685.3, type: .received),
                .init(date: "Oct 12", name: "Acme, Inc", amount: 45, type: .sent),
                .init(date: "Oct 12", name: "Acme, Inc", amount: 45, type: .sent),
                .init(date: "Oct 12", name: "Acme, Inc", amount: 45, type: .received),
                .init(date: "Oct 12", name: "Acme, Inc", amount: 22.99, type: .sent),
                .init(date: "Oct 12", name: "Acme, Inc", amount: 45, type: .sent),
            ])
        
    }
}
