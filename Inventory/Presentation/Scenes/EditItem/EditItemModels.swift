//
//  EditItemModels.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
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
        @Published var showRemoveItemButton = false
        @Published var sceneTitle = Strings.sceneAddTitle
        
        init(isPresented: Binding<Bool>) {
            self.isPresented = isPresented
        }
    }
    
    struct Theme {
        static let tintColor = Color.appTintColor
        static let errorColor = Color.appErrorColor
        static let cancelButtonTitle = Strings.cancelButtonTitle
        static let saveButtonTitle = Strings.saveButtonTitle
        static let deleteButtonTitle = Strings.deleteButtonTitle
    }
    
    enum Strings {
        static let sceneAddTitle = "Add Item"
        static let sceneEditTitle = "Edit Item"
        static let cancelButtonTitle = "Cancel"
        static let saveButtonTitle = "Save"
        static let deleteButtonTitle = "Remove Item"
        static let itemNameTextFieldPlaceholder = "Item name"
        static let itemCountTextFieldPlaceholder = "Item count"
        
        static func displayError(for error: ServiceError) -> ErrorSheet.ViewModel {
            switch error {
            case .saveFailed: return .saveFailed
            case .fetchFailed: return .fetchFailed
            case .invalidInput:
                let message = "Some value is either missing or incorrect. Please make sure all values are entered correctly"
                return .default(with: message)
            case .deleteFailed:
                let message = "Unable to delete. Please try again."
                return .default(with: message)
            }
        }
        
        static let defaultError = ErrorSheet.ViewModel.default
    }
}
