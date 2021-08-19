//
//  ViewItemsOverviewModels.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

extension ViewItemsOverview {
    
    class ViewModel: ObservableObject {
        @Published var items = [ItemsGrid.Item]()
        @Published var showEditItem = false
        @Published var error: ErrorSheet.ViewModel?
    }
    
    struct Theme {
        static let tintColor = Color.appTintColor
        static let itemsTitle = Strings.itemsTitle
    }
    
    enum Strings {
        static let itemsTitle = "Items"
        
        static func displayError(for error: ServiceError) -> ErrorSheet.ViewModel {
            switch error {
            case .fetchFailed: return .fetchFailed
            }
        }
        
        static let defaultError = ErrorSheet.ViewModel.default
    }
}
