//
//  AddNewProjectItemView.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

extension AddNewProjectItem {
    struct ContentView: View {
        typealias Theme = AddNewProjectItem.Theme
        @ObservedObject var viewModel: ViewModel
        let interactor: AddNewProjectItemInteracting
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 16) {
                        Field(info: viewModel.itemNameTextFieldInfo, update: interactor.updateName)
                        Field(info: viewModel.itemCountTextFieldInfo, update: interactor.updateCount)
                            .keyboardType(.numberPad)
                        Field(info: viewModel.numberPerBuildTextFieldInfo, update: interactor.updateNumberPerBuild)
                            .keyboardType(.numberPad)
                    }
                }
                .navigationTitle(Theme.sceneTitle)
                .navigationBarItems(leading: cancelButton, trailing: saveButton)
                .navigationBarBackButtonHidden(true)
                .accentColor(Theme.tintColor)
                .errorSheet($viewModel.error)
            }
            .navigationViewStyle(.stack)
        }
        
        // MARK: - Subviews
        
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

// MARK: - Previews

struct AddNewProjectItem_Previews: PreviewProvider {
    static var previews: some View {
        AddNewProjectItem.Scene().view(preview: true, isPresented: .constant(true))
    }
}
