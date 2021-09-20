//
//  TitleBar.swift
//  Inventory
//
//  Created by Mikael Weiss on 9/20/21.
//

import SwiftUI

struct TitleBar: View {
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
                .accentColor(Color.appTintColor)
                .padding()
                .background(
                    Circle()
                        .fill(Color.appWhite)
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
