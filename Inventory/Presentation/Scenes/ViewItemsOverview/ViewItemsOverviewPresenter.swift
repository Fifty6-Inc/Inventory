//
//  ViewItemsOverviewPresenter.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

protocol ViewItemsOverviewPresenting {
    func presentFetch(_ items: [ViewItemsOverview.ItemDetails])
    func presentShowEditItem()
    func present(error: ViewItemsOverview.ServiceError?)
}

extension ViewItemsOverview {
    
    struct Presenter: ViewItemsOverviewPresenting {
        
        let viewModel: ViewModel
        
        func presentFetch(_ items: [ViewItemsOverview.ItemDetails]) {
            viewModel.items = items.map {
                ViewItemsOverview.ItemViewModel(
                    id: $0.id,
                    name: $0.name,
                    count: String($0.count))
            }
        }
        
        func presentShowEditItem() {
            viewModel.showEditItem = true
        }
        
        func present(error: ServiceError?) {
            if let error = error {
                viewModel.error = Strings.displayError(for: error)
            } else {
                viewModel.error = Strings.defaultError
            }
        }
    }
}
