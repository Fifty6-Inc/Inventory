//
//  ViewItemsOverviewPresenter.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

protocol ViewItemsOverviewPresenting {
    func presentAdd()
    func present(error: ViewItemsOverview.ServiceError)
}

extension ViewItemsOverview {
    
    struct Presenter: ViewItemsOverviewPresenting {
        
        let viewModel: ViewModel
        
        func presentAdd() {
            viewModel.showAddItem = true
        }
        
        func present(error: ServiceError) {
            viewModel.error = Strings.displayError(for: error)
        }
    }
}
