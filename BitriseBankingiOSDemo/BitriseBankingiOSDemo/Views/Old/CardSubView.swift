//
//  CardSubView.swift
//  BitriseBankingiOSDemo
//
//  Created by Balazs Ilsinszki on 2025. 03. 15..
//

import SwiftUI

struct CardShape: Shape {

        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addRoundedRect(in: CGRect(x: 5, y: 50, width: 250, height: 200), cornerSize: CGSize(width: 20, height: 20))
            return path
        }
}

struct CardSubView: View {
    
    @ObservedObject var cardModel: AccountModel
    
    var body: some View {
        VStack {
            Text(cardModel.currencyType?.rawValue ?? "")
            Text(String(cardModel.amount ?? 0))
            Spacer()
                .frame(height: 50)
            Text("💳 ** "+(cardModel.last4Digits ?? ""))
        }
        .frame(width: 120, height: 120)
        .padding().overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 4)
        )                      .accessibilityIdentifier("CardSubView")

    }
}

#Preview {
    CardSubView(cardModel: AccountModel(currencyType: Currency.usd, accountNumber: "1234 1234 1234 1234", amount: 461.12))
}
