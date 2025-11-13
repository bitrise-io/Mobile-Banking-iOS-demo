//
//  Currency.swift
//  BitriseBankingiOSDemo
//
//  Created by Balazs Ilsinszki on 2025. 03. 24..
//

enum Currency: String {
    case unknown = ""
    case usd = "🇺🇸 USD"
    case eur = "🇪🇺 EUR"
    case huf = "🇭🇺 HUF"
    
    init(from string: String) {
        switch string.lowercased() {
        case "usd":
            self = .usd
        case "eur":
            self = .eur
        case "huf":
            self = .huf
        default:
            self = .usd
        }
    }
    
    func toDisplayText() -> String {
        switch self {
        case .usd:
            "🇺🇸 USD"
        case .eur:
            "🇪🇺 EUR"
        case .huf:
            "🇭🇺 HUF"
        default:
            "🇺🇸 USD"
        }
    }
    
    func toAPIParam() -> String {
        switch self {
        case .usd:
            "USD"
        case .eur:
            "EUR"
        case .huf:
            "HUF"
        default:
            "USD"
        }
    }
    
    static func concurrencies() -> [Currency] {
        [.usd, .eur, .huf]
    }
}
