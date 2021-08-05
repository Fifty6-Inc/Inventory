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
        static let addItemButtonTitle = "Add Item"
        static let tintColor = Color.appTintColor
    }
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showAddItem = false
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
                    ZStack {
                        Text("No unused items here!")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.horizontal)
                        
                        StandardButton(
                            title: Theme.addItemButtonTitle,
                            action: didTapAddItem)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                }
            }
            .navigationBarItems(leading: cancelButton)
            .sheet(isPresented: $showAddItem) {
                EditItem.Scene().view(isPresented: $showAddItem)
            }
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
    
    func didTapAddItem() {
        EditItem.prepareIncomingRoute(with: nil)
        showAddItem = true
    }
}

struct AllItemsGrid_Previews: PreviewProvider {
    static var previews: some View {
        AllItemsGrid(items: [], didTapItem: { _ in })
    }
}
