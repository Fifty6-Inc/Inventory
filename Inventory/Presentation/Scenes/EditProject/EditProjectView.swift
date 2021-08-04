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
                        
                        ItemsGrid(
                            items: viewModel.projectItems,
                            didTapItem: didTapProjectItem,
                            didTapAdd: didTapAdd)
                            .padding(.horizontal)
                        
                        Spacer().frame(height: 50)
                        
                        DeleteButton(title: Theme.deleteButtonTitle, onTap: interactor.delete)
                            .opacity(viewModel.showRemoveProjectButton ? 1 : 0)
                    }
                }
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle(viewModel.sceneTitle)
                .navigationBarItems(leading: cancelButton, trailing: saveButton)
                .navigationBarBackButtonHidden(true)
                .accentColor(Theme.tintColor)
                .errorSheet($viewModel.error)
                .actionSheet(isPresented: $showConfirmRemoveItem) {
                    var buttons = [ActionSheet.Button]()
                    
                    buttons.append(.destructive(
                        Text(Theme.deleteItemButtonTitle),
                        action: { didTapRemoveItem(with: selectedID) } ))
                    buttons.append(.cancel(Text(Theme.cancelButtonTitle)))
                    
                    return ActionSheet(title: Text(""), message: nil, buttons: buttons)
                }
                .sheet(isPresented: $showAddItemSheet) {
                    ItemsGrid(
                        items: viewModel.allItems,
                        didTapItem: didTapNewItem)
                }
            }
        }
        
        private struct CountButton: View {
            let imageName: String
            let onTap: () -> Void
            
            var body: some View {
                Button(action: onTap) {
                    Circle()
                        .fill(Color.appTintColor)
                        .frame(width: 64, height: 64)
                        .inverseMask {
                            Image(systemName: imageName)
                                .font(.system(size: 36, weight: .heavy, design: .rounded))
                        }
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
    }
}

// MARK: - Interacting

extension EditProject.ContentView {
    func didTapProjectItem(_ id: UUID) {
        showConfirmRemoveItem = true
        selectedID = id
    }
    
    func didTapRemoveItem(with id: UUID?) {
        if let id = id {
            interactor.removeItem(with: id)
        }
    }

    func didTapAdd() {
        showAddItemSheet = true
    }
    
    func didTapNewItem(with id: UUID) {
        interactor.addItem(with: id)
        showAddItemSheet = false
    }
}

// MARK: - Previews

struct EditProject_Previews: PreviewProvider {
    static var previews: some View {
        EditProject.Scene().view(preview: true, isPresented: .constant(true))
    }
}
