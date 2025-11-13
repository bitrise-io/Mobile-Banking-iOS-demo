//
//  HomeView.swift
//  BitriseBankingiOSDemo
//
//  Created by Szabolcs Toth on 2025. 10. 14..
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var model: MainViewModel
    
    @State fileprivate var showAlert = false

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 20) {
                HeaderBar {
                    showAlert = true
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Logged in with \(model.currentAccount().email)"),
                        message: Text("Are you sure you want to log out?"),
                        primaryButton: .destructive(Text("Logout")) {
                            model.logout()
                        },
                        secondaryButton: .cancel()
                    )
                }
                .onAppear {
                    showAlert = false
                }
                
                AccountView(account: model.currentAccount())
                
                Divider().background(Brand.divider)
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                
                Transactions(transactions: model.currentAccount().transactions)
            }
        }
    }
}

private struct HeaderBar: View {
    var onAccountTap: () -> Void = {}
    
    var body: some View {
        ZStack {
            Brand.purple
                .ignoresSafeArea(edges: .top)

            HStack(spacing: 12) {
                Image("HomeLogo")
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(height: 28)
                
                Spacer()

                Button(action: onAccountTap) {
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .semibold))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 64)
    }
}

private struct AccountView: View {
    let account: DemoAccount
    
    var body: some View {
        VStack(spacing: 22) {
            HStack(spacing: 12) {
                Text(account.currency.toDisplayText())
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Brand.text)
                
                Spacer()
                
                DotMenu()
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            
            Text(String(format: "%.2f", account.amount))
                .font(.system(size: 52, weight: .heavy))
                .kerning(-1)
                .foregroundColor(Brand.text)
                .frame(maxWidth: .infinity, alignment: .center)
            
            AccountSwitcherView()
                .padding(.top, 0)
            
            HStack(spacing: 22) {
                QuickAction(icon: "plus", title: "Add")
                QuickAction(icon: "arrow.left.arrow.right", title: "Convert")
                QuickAction(icon: "arrow.up", title: "Send")
                QuickAction(icon: "arrow.down", title: "Request")
            }
            .padding(.top, 6)
            
        }
    }
}

private struct AccountSwitcherView: View {
    var onTap: () -> Void = {}
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 14, weight: .semibold))
                Text("Account")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(Brand.purple)
            .frame(height: 36)
            .padding(.horizontal, 14)
            .background(
                Capsule()
                    .fill(Brand.purple10)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct DotMenu: View {
    var onTap: () -> Void = {}
    
    var body: some View {
        Button(action: { onTap() }) {
            Text("•••")
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundColor(Brand.purple)
                .frame(width: 38, height: 34)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Brand.purple10)
                )
        }
        .buttonStyle(.plain)
    }
}

private struct QuickAction: View {
    let icon: String
    let title: String
    
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Brand.purple06)
                    .frame(width: 64, height: 64)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Brand.purple)
                    )
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Brand.purpleDark)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .accessibilityLabel(title)
        }
        .buttonStyle(.plain)
    }
}

private struct Transactions: View {
    let transactions: [DemoTransaction]

    var body: some View {
            VStack(spacing: 0) {
                header
                ScrollView {
                    LazyVStack(spacing: 6) {
                        ForEach(transactions) { transaction in
                            TransactionRow(
                                direction: transaction.type == .sent ? .up : .down,
                                title: transaction.name,
                                date: transaction.date,
                                amount: transaction.amount,
                                color: transaction.type == .sent ? Brand.red : Brand.green
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
                .padding(.top, 10)
            }
        }

        private var header: some View {
            HStack {
                Text("Transactions")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Brand.purpleDark)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)
            .background(Color(.systemBackground))
            .zIndex(1)
        }
}

private enum Direction {
    case up, down
}

private struct ArrowCircle: View {
    let direction: Direction
    var body: some View {
        let name: String = {
            switch direction {
            case .up: return "arrow.up"
            case .down: return "arrow.down"
            }
        }()

        return Circle()
            .fill(Brand.purple06)
            .frame(width: 44, height: 44)
            .overlay(
                Image(systemName: name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Brand.purple)
            )
    }
}

private struct TransactionRow: View {
    let direction: Direction
    let title: String
    let date: String
    let amount: Double
    let color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            ArrowCircle(direction: direction)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Brand.text)
                Text(date)
                    .font(.system(size: 14))
                    .foregroundColor(Brand.textSecondary)
            }

            Spacer()
            
            Text(amountString())
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 12)
        .overlay(Divider().background(Brand.divider), alignment: .bottom)
    }
    
    func amountString() -> String {
        if direction == .up {
            return String(format: "- %.2f", amount)
        } else {
            return String(format: "+ %.2f", amount)
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView(model: MainViewModel())
}
