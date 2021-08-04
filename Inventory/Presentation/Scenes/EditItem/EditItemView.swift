//
//  EditItemView.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import SwiftUI

extension EditItem {
    
    struct ContentView: View {
        typealias Theme = EditItem.Theme
        @ObservedObject var viewModel: ViewModel
        let interactor: EditItemInteracting
        
        var body: some View {
            NavigationView {
                VStack(spacing: 16) {
                    Field(info: viewModel.itemNameTextFieldInfo, update: interactor.updateName)
                    Field(info: viewModel.itemCountTextFieldInfo, update: interactor.updateCount)
                    
                    Spacer()
                    
                    HStack(spacing: 36) {
                        CountButton(imageName: "minus", onTap: interactor.subtractFromCount)
                        CountButton(imageName: "plus", onTap: interactor.addToCount)
                    }
                }
                .padding(.top)
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle(Theme.sceneTitle)
                .navigationBarItems(leading: cancelButton, trailing: saveButton)
                .navigationBarBackButtonHidden(true)
                .accentColor(Theme.tintColor)
                .errorSheet($viewModel.error)
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
                Text(Theme.backButtonTitle)
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

struct EditItem_Previews: PreviewProvider {
    static var previews: some View {
        EditItem.Scene().view(preview: true, isPresented: .constant(true))
    }
}
