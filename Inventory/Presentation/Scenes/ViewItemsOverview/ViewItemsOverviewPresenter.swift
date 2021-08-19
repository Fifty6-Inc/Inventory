//
//  ViewItemsOverviewPresenter.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
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
            let gridItems = items.map {
                ItemsGrid.Item(
                    id: $0.id,
                    name: $0.name,
                    count: "Count: \($0.count)",
                    numberPerBuild: nil)
            }
            
            viewModel.items = gridItems.sorted(by: { $0.name < $1.name })
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
