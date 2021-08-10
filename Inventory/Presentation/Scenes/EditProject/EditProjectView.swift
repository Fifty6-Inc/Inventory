//
//  EditProjectView.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import SwiftUI

extension EditProject {
    
    struct ContentView: View {
        @State private var showActionSheet = false
        @State private var showConfirmRemoveItem = false
        @State private var selectedID: UUID? = nil
        @State private var showAddItemSheet = false
        typealias Theme = EditProject.Theme
        @ObservedObject var viewModel: ViewModel
        let interactor: EditProjectInteracting
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 16) {
                        Field(info: viewModel.projectNameTextFieldInfo, update: interactor.updateName)
                        
                        Text(Theme.itemsTitle)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                        
                        ItemsGrid(
                            items: viewModel.projectItems,
                            didTapItem: didTapProjectItem,
                            didTapAdd: didTapAddItem)
                            .padding(.horizontal)
                        
                        Spacer().frame(height: 50)
                        
                        DeleteButton(title: Theme.deleteButtonTitle, onTap: didTapDelete)
                            .opacity(viewModel.showRemoveProjectButton ? 1 : 0)
                    }
                }
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle(viewModel.sceneTitle)
                .navigationBarItems(leading: cancelButton, trailing: saveButton)
                .navigationBarBackButtonHidden(true)
                .accentColor(Theme.tintColor)
                .errorSheet($viewModel.error)
                .actionSheet(isPresented: $showActionSheet) {
                    if showConfirmRemoveItem {
                        return confirmRemoveItemActionSheet
                    } else {
                        return confirmDeleteProjectActionSheet
                    }
                }
                .sheet(isPresented: $showAddItemSheet) {
                    AllItemsGrid(
                        items: viewModel.allItems,
                        addProjectItem: addProjectItem(with:))
                }
            }
        }
        
        private struct Field: View {
            let info: TextFieldInfo
            let update: (String) -> Void
            
            private var text: Binding<String> {
                Binding(get: { info.value }, set: update)
            }
            
            var body: some View {
                TextField(info.placeholder, text: text)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(lineWidth: 2)
                            .fill(info.borderColor)
                    )
                    .padding(.horizontal)
            }
        }
        
        var cancelButton: some View {
            Button(action: interactor.dismiss) {
                Text(Theme.cancelButtonTitle)
                    .accentColor(Theme.tintColor)
            }
        }
        
        var saveButton: some View {
            Button(action: interactor.save) {
                Text(Theme.saveButtonTitle)
                    .accentColor(Theme.tintColor)
            }.disabled(!viewModel.canSave)
        }
        
        var confirmRemoveItemActionSheet: ActionSheet {
            var buttons = [ActionSheet.Button]()
            
            buttons.append(.destructive(
                Text(Theme.confirmRemoveItemButtonTitle),
                action: { didTapRemoveItem(with: selectedID) }
            ))
            buttons.append(.cancel(
                Text(Theme.cancelButtonTitle),
                action: cancelRemoveItem
            ))
            
            return ActionSheet(
                title: Text(Theme.confirmRemoveItemTitle),
                message: Text(Theme.confirmRemoveItemMessage),
                buttons: buttons)
        }
        
        var confirmDeleteProjectActionSheet: ActionSheet {
            var buttons = [ActionSheet.Button]()
            
            buttons.append(.destructive(
                Text(Theme.confirmDeleteProjectButtonTitle),
                action: interactor.delete))
            buttons.append(.cancel(Text(Theme.cancelButtonTitle)))
            
            return ActionSheet(
                title: Text(Theme.confirmDeleteProjectTitle),
                message: Text(Theme.confirmDeleteProjectMessage),
                buttons: buttons)
        }
    }
}

// MARK: - Interacting

extension EditProject.ContentView {
    func didTapProjectItem(_ id: UUID) {
        showConfirmRemoveItem = true
        showActionSheet = true
        selectedID = id
    }
    
    func cancelRemoveItem() {
        selectedID = nil
    }
    
    func didTapRemoveItem(with id: UUID?) {
        if let id = id {
            interactor.removeItem(with: id)
        }
    }

    func didTapAddItem() {
        showAddItemSheet = true
    }
    
    func didTapDelete() {
        showConfirmRemoveItem = false
        showActionSheet = true
    }
    
    func addProjectItem(with request: EditProject.AddProjectItem.Request) {
        interactor.addProjectItem(with: request)
        showAddItemSheet = false
    }
}

// MARK: - Previews

struct EditProject_Previews: PreviewProvider {
    static var previews: some View {
        EditProject.Scene().view(preview: true, isPresented: .constant(true))
    }
}
