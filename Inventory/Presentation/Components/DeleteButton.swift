//
//  DeleteButton.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//

import SwiftUI

struct DeleteButton: View {
    let title: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: "minus.circle.fill")
                Text(title)
            }
            .foregroundColor(.appErrorColor)
            .padding()
        }
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton(title: "Remove Item") {}
    }
}
