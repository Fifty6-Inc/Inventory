//
//  AllItemsGrid.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//

import SwiftUI

struct AllItemsGrid: View {
    enum Theme {
        static let cancelButtonTitle = "Cancel"
        static let tintColor = Color.appTintColor
    }
    
    @Environment(\.presentationMode) var presentationMode
    let items: [ItemsGrid.Item]
    let didTapItem: (UUID) -> Void
    
    var body: some View {
        NavigationView {
            Group {
                if items.count > 0 {
                    ScrollView {
                        ItemsGrid(
                            items: items,
                            didTapItem: didTapItem)
                            .padding(.horizontal)
                    }
                } else {
                    Text("No unused items here!")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.heavy)
                        .padding(.horizontal)
                }
            }
            .navigationBarItems(leading: cancelButton)
        }
    }
    
    var cancelButton: some View {
        Button(action: dismiss) {
            Text(Theme.cancelButtonTitle)
                .accentColor(Theme.tintColor)
        }
    }
    
    // MARK: - Interacting
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct AllItemsGrid_Previews: PreviewProvider {
    static var previews: some View {
        AllItemsGrid(items: [], didTapItem: { _ in })
    }
}
