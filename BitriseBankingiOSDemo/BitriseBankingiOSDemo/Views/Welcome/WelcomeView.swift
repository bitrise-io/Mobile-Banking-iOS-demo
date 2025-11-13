//
//  WelcomeView.swift
//  BitriseBankingiOSDemo
//
//  Created by Szabolcs Toth on 2025. 10. 14..
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var model: MainViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword = false
    @State private var isLoading = false

    @FocusState private var focused: Field?
    private enum Field { case email, password }
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Image("HomeLogo")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(height: 28)
                    
                    Spacer(minLength: 100)
                    
                    Text("Welcome back")
                        .font(.system(size: 32, weight: .heavy))
                        .foregroundColor(Brand.text)
                        .padding(.top, 8)

                    Text("Enter your credentials associated with your bitriseBank account.")
                        .font(.system(size: 17))
                        .foregroundColor(Brand.textSecondary)
                        .padding(.top, 6)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(alignment: .leading, spacing: 14) {
                        InputField {
                            TextField("", text: $email)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .keyboardType(.emailAddress)
                                .focused($focused, equals: .email)
                                .submitLabel(.next)
                                .onSubmit { focused = .password }
                                .font(.system(size: 17))
                                .frame(height: 22)
                                .placeholder(email.isEmpty) {
                                    Text(verbatim: "john.doe@email.com")
                                        .textSelection(.disabled)
                                        .foregroundColor(Brand.placeholder)
                                }
                        }

                        InputField {
                            HStack(spacing: 8) {
                                Group {
                                    if showPassword {
                                        TextField("", text: $password)
                                    } else {
                                        SecureField("", text: $password)
                                    }
                                }
                                .placeholder(password.isEmpty) {
                                    Text(verbatim: "****")
                                        .textSelection(.disabled)
                                        .foregroundColor(Brand.placeholder)
                                }
                                .focused($focused, equals: .password)
                                .submitLabel(.go)
                                .onSubmit(submit)

                                Button {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        showPassword.toggle()
                                    }
                                } label: {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundColor(Brand.textSecondary)
                                        .font(.system(size: 18, weight: .semibold))
                                        .padding(.horizontal, 2)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel(showPassword ? "Hide password" : "Show password")
                            }
                            .font(.system(size: 17))
                        }
                    }
                    .padding(.top, 24)

                    Spacer(minLength: 280)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack {
                Button(action: submit) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Brand.purple)
                            .frame(height: 56)
                            .opacity(canSubmit ? 1 : 0.5)

                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Continue")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .disabled(!canSubmit || isLoading)
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.top, 6)
                .padding(.bottom, 16)
            }
            .background(Color(.systemBackground).ignoresSafeArea(edges: .bottom))
        }
    }
    
    private var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty
    }

    private func submit() {
        guard canSubmit else { return }
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoading = false
            
            model.email = email.trimmingCharacters(in: .whitespaces)
            model.login()
        }
    }
}

private struct InputField<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }

    var body: some View {
        HStack(spacing: 12) {
            content
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Brand.fieldStroke, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.02), radius: 2, x: 0, y: 1)
    }
}

extension View {
    func placeholder<Content: View>(_ shouldShow: Bool,
                                    alignment: Alignment = .leading,
                                    @ViewBuilder content: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            content().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Preview

#Preview {
    WelcomeView(model: MainViewModel())
}
