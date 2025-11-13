//
//  ContentView.swift
//  BitriseBankingiOSDemo
//
//  Created by Balazs Ilsinszki on 2025. 03. 15..
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = MainViewModel()
    
    var body: some View {
        if model.isLoggedIn {
            HomeView(model: model)
        } else {
            WelcomeView(model: model)
        }
    }
}

#Preview {
    ContentView()
}
