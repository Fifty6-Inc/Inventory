//
//  ViewItemsOverviewModels.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI

extension ViewItemsOverview {
    
    class ViewModel: ObservableObject {
        @Published var showAddItem = false
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
            case .saveFailed:
                return .saveFailed
            }
        }
    }
}
