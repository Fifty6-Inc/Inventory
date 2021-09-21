//
//  StandardButton.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

struct StandardButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Color.appTintColor.cornerRadius(33)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .overlay(
                    Text(title.uppercased())
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.appWhite)
                )
        }
    }
}

struct StandardButton_Previews: PreviewProvider {
    static var previews: some View {
        StandardButton(title: "Okay", action: {})
    }
}
