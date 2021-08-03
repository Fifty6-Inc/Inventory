//
//  EditItemModels.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI

extension EditItem {
    
    struct TextFieldInfo {
        var placeholder = ""
        var value = ""
        var state: ValidationError? = nil
        var borderColor = Theme.tintColor
    }
    
    class ViewModel: ObservableObject {
        let isPresented: Binding<Bool>
        @Published var canSave = false
        @Published var error: ErrorSheet.ViewModel?
        @Published var itemNameTextFieldInfo = TextFieldInfo(placeholder: Strings.itemNameTextFieldPlaceholder)
        @Published var itemCountTextFieldInfo = TextFieldInfo(placeholder: Strings.itemCountTextFieldPlaceholder)
        
        init(isPresented: Binding<Bool>) {
            self.isPresented = isPresented
        }
    }
    
    struct Theme {
        static let tintColor = Color.appTintColor
        static let errorColor = Color.appErrorColor
        static let sceneTitle = Strings.sceneTitle
        static let backButtonTitle = Strings.cancelButtonTitle
        static let saveButtonTitle = Strings.saveButtonTitle
    }
    
    enum Strings {
        static let sceneTitle = "Edit Item"
        static let cancelButtonTitle = "Cancel"
        static let saveButtonTitle = "Save"
        static let itemNameTextFieldPlaceholder = "Item name"
        static let itemCountTextFieldPlaceholder = "Item count"
        
        static func displayError(for error: ServiceError) -> ErrorSheet.ViewModel {
            switch error {
            case .saveFailed:
                return .saveFailed
            }
        }
    }
}
