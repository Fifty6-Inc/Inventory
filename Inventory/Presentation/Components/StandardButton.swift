//
//  StandardButton.swift
//  Raindrop
//
//  Created by Mikael Weiss on 6/16/21.
//

import SwiftUI

struct StandardButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title.uppercased())
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .accentColor(.appGrayDark)
        }
        .background(Color.appDeepBlue.cornerRadius(33))
    }
}

struct StandardButton_Previews: PreviewProvider {
    static var previews: some View {
        StandardButton(title: "Okay", action: {})
    }
}
