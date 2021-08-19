//
//  StandardButton.swift
//  Inventory
//
//  Created by Mikael Weiss on 6/16/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

struct StandardButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Color.appDeepBlue.cornerRadius(33)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .inverseMask {
                    Text(title.uppercased())
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
        }
    }
}

struct StandardButton_Previews: PreviewProvider {
    static var previews: some View {
        StandardButton(title: "Okay", action: {})
    }
}
