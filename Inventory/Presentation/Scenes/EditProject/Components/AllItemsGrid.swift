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
        /// Using this instead of presentation mode because sometimes `presentationMode.wrappedValue.dismiss()` fails
        @Binding var isShowing: Bool
        let items: [ItemsGrid.Item]
        let addProjectItem: (AddProjectItem.Request) -> Void
        let addItemAndProjectItem: (AddItemAndProjectItem.Request) -> Void
        
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
                            AddNewProjectItem.Scene().view(isPresented: $showAddItem)
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
                Text(Theme.doneButtonTitle)
                    .accentColor(Theme.tintColor)
            }
        }
        
        // MARK: - Interacting
        
        func dismiss() {
            isShowing = false
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
        }
        
        func didTapAddItem() {
            AddNewProjectItem.prepareIncomingRoute { itemInfo in
                let request = AddItemAndProjectItem.Request(
                    name: itemInfo.name,
                    count: itemInfo.count,
                    numberRequiredPerBuild: itemInfo.numberRequiredPerBuild)
                addItemAndProjectItem(request)
            }
            showAddItem = true
        }
    }
}

struct AllItemsGrid_Previews: PreviewProvider {
    static var previews: some View {
        EditProject.AllItemsGrid(isShowing: .constant(true), items: [], addProjectItem: { _ in }, addItemAndProjectItem: { _ in })
    }
}
