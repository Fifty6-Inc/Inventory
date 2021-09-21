//
//  TitleBar.swift
//  Inventory
//
//  Created by Mikael Weiss on 9/20/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

struct TitleBar: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Spacer()
            addButton
        }
        .padding([.top, .horizontal], 20)
    }
    
    var addButton: some View {
        Button(action: onAdd) {
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .heavy, design: .rounded))
                .contentShape(Rectangle())
                .accentColor(colorScheme == .light ? .appTintColor : .appWhite)
                .padding()
                .background(
                    Circle()
                        .fill(colorScheme == .light ? Color.appWhite : Color.appDeepBlue)
                        .shadow(radius: 10)
                        .frame(maxHeight: 45)
                )
        }
    }
}

struct TitleBar_Previews: PreviewProvider {
    static var previews: some View {
        TitleBar(title: "Some Title", onAdd: { })
    }
}
