//
//  ViewItemsOverviewInteractor.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ViewItemsOverviewInteracting {
    func add()
}

extension ViewItemsOverview {
    
    struct Interactor: ViewItemsOverviewInteracting {
        let service: ViewItemsOverviewService
        let presenter: ViewItemsOverviewPresenting
        
        func add() {
            presenter.presentAdd()
        }
    }
}
