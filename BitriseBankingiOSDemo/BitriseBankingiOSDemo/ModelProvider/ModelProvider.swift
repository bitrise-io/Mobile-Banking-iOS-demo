//
//  ModelProvider.swift
//  BitriseBankingiOSDemo
//
//  Created by Balazs Ilsinszki on 2025. 03. 15..
//

import Foundation

import Amplify
import AWSAPIPlugin

class ModelProvider {
    
    static func getAccountModels(userID: String) async -> Array<AccountModel>? {
    
        var accountModels: Array<AccountModel>? = nil
        
        configureAmplify()
        
        do {
            let path = "/users/\(userID)/accounts"
            
            let requestBody: [String: String] = ["currency": "USD"]
            let jsonData = try JSONEncoder().encode(requestBody)
            
            let request = RESTRequest(path: path, headers: ["Content-Type": "application/json"])
            
            do {
                let data = try await Amplify.API.get(request: request)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                                
                accountModels = Array()
                if let jsonArray = jsonObject as? [[String: Any]] {
                    for dict in jsonArray {
                        guard let model = AccountModel(json: dict) else { return nil }
                        accountModels?.insert(model, at: 0)
                    }
                }
                
                print("We've got \(accountModels?.count) accounts")
                
            } catch let error as APIError {
                print("Failed due to API error: ", error)
            } catch {
                print("Unexpected error: \(error)")
            }
            
        } catch {
            print("Failed Amplify call: \(error)")
        }
        
        //try? await Task.sleep(for: .seconds(2))
        //return [
        //    AccountModel(currencyType: Currency.usd, cardNumber: "1234 5678 1234 1234", amount:634.1),
        //    AccountModel(currencyType: Currency.eur, cardNumber: "1234 5678 1234 1234", amount:234.1),
        //    AccountModel(currencyType: Currency.huf, cardNumber: "1234 5678 1234 1234", amount:66234.1)
        //]
        
        return accountModels
    }
    
    static func addAccount(userID: String, currency: Currency) async {
        configureAmplify()
        
        do {
            let path = "/users/\(userID)/accounts"
            
            let requestBody: [String: String] = ["currency": currency.toAPIParam()]
            let jsonData = try JSONEncoder().encode(requestBody)
            
            let request = RESTRequest(path: path, headers: ["Content-Type": "application/json"], body: jsonData)
            
            do {
                let data = try await Amplify.API.post(request: request)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                print("We've got a new account \(jsonObject)")
            } catch let error as APIError {
                print("Failed due to API error: ", error)
            } catch {
                print("Unexpected error: \(error)")
            }
            
        } catch {
            print("Failed Amplify call: \(error)")
        }
    }
    
    static private func configureAmplify() {
        do {
            if Amplify.API.isConfigured  {
                print("Amplify configured skip, as it's already setup")
            }
            else {
                print("Amplify configure")
                try Amplify.add(plugin: AWSAPIPlugin())
                try Amplify.configure()
                print("Amplify configured successfully")
            }
        } catch {
            print("Failed to configure Amplify: \(error)")
        }
    }
    
}
