//
//  MainView.swift
//  BitriseBankingiOSDemo
//
//  Created by Balazs Ilsinszki on 2025. 03. 15..
//

import SwiftUI

struct MainView: View {
    @ObservedObject var model: MainViewModel
    @State fileprivate var showAlert = false
    
    @State private var showCurrencyPicker = false
    @State var selectedCurrency = Currency.usd
    
    var body: some View {
        
        NavigationView {
            VStack {
                LeftAlignedTitle(text:"Currencies", showButton: true, buttonAction: {
                    showCurrencyPicker.toggle()
                })
                .padding(.top, 20)
                
                if model.accountModels?.isEmpty ?? true {
                    Text("No accounts yet, add your first account by tapping the plus (+) button")
                        .foregroundColor(.secondary)
                    
                    Spacer().frame(height: 50)
                }
                else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(model.accountModels!) { card in
                                CardSubView(cardModel: card)
                                    .padding()
                            }
                        }
                    }
                    .padding()
                }
                
                LeftAlignedTitle(text:"Transactions")
                    
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .navigationTitle("Home") // Title of the Navigation Bar
            .navigationBarItems(trailing: logoutButton)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Confirm Logout"),
                    message: Text("Are you sure you want to log out?"),
                    primaryButton: .destructive(Text("Logout")) {
                        model.logout()
                    },
                    secondaryButton: .cancel() // Cancel button
                )
            }
            .onAppear {
                showAlert = false
            }.popover(isPresented: $showCurrencyPicker) {
                CurrencyPickerView(
                    selectedCurrency: $selectedCurrency,
                    currencies: Currency.concurrencies()
                )
            }.onChange(of: selectedCurrency, { oldValue, newValue in
                model.addAccount(currency: newValue)
            })
        }
    }

    var logoutButton: some View {
        Button(action: {
            showAlert = true
            //model.logout()
        }) {
            Text("Logout")
                .foregroundColor(.blue) // Change color as needed
        }
    }
    
}

#Preview {    
    MainView(model: MainViewModel())
}
