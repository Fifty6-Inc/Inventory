//
//  NumberPerBuild.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/10/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

extension EditProject {
    struct NumberPerBuild: View {
        typealias Theme = EditProject.Theme
        @Environment(\.presentationMode) var presentationMode
        @State private var text = ""
        let itemName: String
        let onSave: (Int) -> Void
        
        private var saveDisabled: Bool {
            Int(text) == nil
        }
        
        private var textHidden: Bool {
            Int(text) != nil || text == ""
        }
        
        var body: some View {
            NavigationView {
                VStack {
                    TextField(Theme.numberPerBuildTitle, text: $text)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .stroke(lineWidth: 2)
                                .fill(Theme.tintColor)
                        )
                        .keyboardType(.numberPad)
                    Text(Theme.mustBeIntegerValueTextFieldErrorMessage)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .foregroundColor(Theme.errorColor)
                        .opacity(textHidden ? 0 : 1)
                        .animation(.default)
                }
                .padding(.horizontal)
                .navigationTitle(itemName)
                .navigationBarItems(leading: cancelButton, trailing: saveButton)
                .navigationBarBackButtonHidden(true)
                .accentColor(Theme.tintColor)
            }
        }
        
        var cancelButton: some View {
            Button(action: cancel) {
                Text(Theme.cancelButtonTitle)
                    .accentColor(Theme.tintColor)
            }
        }
        
        var saveButton: some View {
            Button(action: save) {
                Text(Theme.saveButtonTitle)
                    .accentColor(Theme.tintColor)
            }.disabled(saveDisabled)
        }
        
        // MARK: - Interacting
        
        func cancel() {
            presentationMode.wrappedValue.dismiss()
        }
        
        func save() {
            onSave(Int(text) ?? 0)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct NumberPerBuild_Previews: PreviewProvider {
    static var previews: some View {
        EditProject.NumberPerBuild(itemName: "Bolts", onSave: { _ in })
    }
}
