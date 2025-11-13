//
//  LeftAlignedTitle.swift
//  BitriseBankingiOSDemo
//
//  Created by Balazs Ilsinszki on 2025. 03. 24..
//

import SwiftUI

struct LeftAlignedTitle: View {
    var text = ""
    var showButton = false
    var buttonAction: (() -> Void)?
    
    var body: some View {
        HStack() {
            Text(text)
                .font(.title)
            
            if showButton {
                Button(action: {
                    buttonAction?()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.blue)
                        .frame(width: 40, height: 40)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                        .accessibilityIdentifier("PlusButton")
                }
            }
            
            Spacer()
        }
    }
}
