//
//  Colors.swift
//  BitriseBankingiOSDemo
//
//  Created by Szabolcs Toth on 2025. 10. 14..
//

import SwiftUI

enum Brand {
    static let purple      = Color(hex: 0x5B2A86)
    static let purpleDark  = Color(hex: 0x4A1F6D)
    static let purple10    = Color(hex: 0x5B2A86, alpha: 0.10)
    static let purple06    = Color(hex: 0x5B2A86, alpha: 0.06)
    static let green       = Color(hex: 0x12A150)
    static let red         = Color(hex: 0xE04444)
    static let text        = Color(hex: 0x15121A)
    static let textSecondary = Color(hex: 0x6C6178)
    static let divider     = Color(hex: 0xEDE9F3)
    static let cardBg      = Color.white
    static let circle      = Color(hex: 0x244AA5)
    static let star      = Color(hex: 0xFFCC00)
    static let placeholder    = Brand.divider
    static let fieldStroke    = Color(hex: 0xE7E1EC)
}

private extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
