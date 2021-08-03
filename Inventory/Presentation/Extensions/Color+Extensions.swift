//
//  Color+Extensions.swift
//  Raindrop
//
//  Created by Mikael Weiss on 5/8/21.
//

import SwiftUI

extension Color {
    static let appTintColor = Color("AccentColor")
    static let appErrorColor = Color("appErrorColor")
    static let appGrayLight = Color("appGrayLight")
    static let appGrayMedium = Color("appGrayMedium")
    static let appGrayDark = Color("appGrayDark")
    static let appWhite = Color("appWhite")
    static let appGray = Color("appGray")
    static let appDeepBlue = Color("appDeepBlue")
}

extension Color {
    /// Example: Color(hex: 0xA10115)
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
