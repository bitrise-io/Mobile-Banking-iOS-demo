//
//  PickerView.swift
//  BitriseBankingiOSDemo
//
//  Created by Balazs Ilsinszki on 2025. 06. 18..
//

import SwiftUI

struct CurrencyPickerView: View {
    @Binding var selectedCurrency: Currency
    let currencies: [Currency]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(currencies, id: \.self) { currency in
                Button(action: {
                    selectedCurrency = currency
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(currency.toDisplayText())
                }
            }
            .navigationTitle("Select Currency")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
