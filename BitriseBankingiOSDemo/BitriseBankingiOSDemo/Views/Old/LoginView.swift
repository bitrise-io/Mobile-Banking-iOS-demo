//
//  LoginView.swift
//  BitriseBankingiOSDemo
//
//  Created by Balazs Ilsinszki on 2025. 03. 15..
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var model: MainViewModel
    @State private var password = ""
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                TextField("Email", text: $model.email)
                    .textFieldStyle(.roundedBorder)
                    .padding(.top, 50)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                HStack(spacing: 20) {
                    Spacer()
                    
                    Button(action: {
                        model.login()
                        Task {
                            await model.refreshCards()
                        }
                    }) {
                        Text("Login")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        
                    }) {
                        Text("Register")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                Spacer()
                
            }
            .navigationTitle("Login")
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
    }
}

#Preview {
    LoginView(model:MainViewModel())
}
