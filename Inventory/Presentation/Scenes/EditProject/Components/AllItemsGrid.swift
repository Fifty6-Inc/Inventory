//
//  AllItemsGrid.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

extension EditProject {
    struct AllItemsGrid: View {
        @State private var showNumberPerBuildSheet = false
        @State private var selectedItemID: UUID? = nil
        @State private var showAddItem = false
        typealias Theme = EditProject.Theme
        @Environment(\.presentationMode) var presentationMode
        let items: [ItemsGrid.Item]
        let addProjectItem: (AddProjectItem.Request) -> Void
        
        private var itemName: String {
            let firstItem = items.first { item in
                item.id == selectedItemID
            }
            return firstItem?.name ?? ""
        }
        
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
                            Text(Theme.noUnusedItems)
                                .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.heavy)
                                .padding(.horizontal)
                                .frame(maxHeight: .infinity, alignment: .center)
                                .ignoresSafeArea()
                            
                            StandardButton(
                                title: Theme.addItemButtonTitle,
                                action: didTapAddItem)
                                .frame(maxHeight: .infinity, alignment: .bottom)
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                        .sheet(isPresented: $showAddItem) {
                            EditItem.Scene().view(isPresented: $showAddItem)
                        }
                    }
                }
                .navigationBarItems(leading: cancelButton)
                .navigationBarBackButtonHidden(true)
                .accentColor(Theme.tintColor)
                .sheet(isPresented: $showNumberPerBuildSheet) {
                    NumberPerBuild(itemName: itemName, onSave: onSave)
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
        
        func didTapItem(_ id: UUID) {
            selectedItemID = id
            showNumberPerBuildSheet = true
        }
        
        func onSave(_ numberRequiredPerBuild: Int) {
            guard let itemID = selectedItemID else { return }
            let request = AddProjectItem.Request(
                itemID: itemID,
                numberRequiredPerBuild: numberRequiredPerBuild)
            
            addProjectItem(request)
            showNumberPerBuildSheet = false
            dismiss()
        }
        
        func didTapAddItem() {
            EditItem.prepareIncomingRoute(with: nil)
            showAddItem = true
        }
    }
}

struct AllItemsGrid_Previews: PreviewProvider {
    static var previews: some View {
        EditProject.AllItemsGrid(items: [], addProjectItem: { _ in })
    }
}
