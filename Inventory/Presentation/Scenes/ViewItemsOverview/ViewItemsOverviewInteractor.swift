//
//  ViewItemsOverviewInteractor.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation
import Combine

protocol ViewItemsOverviewInteracting {
    func fetchItems()
    func didTapItem(with id: UUID)
    func add()
}

extension ViewItemsOverview {
    
    struct Interactor: ViewItemsOverviewInteracting {
        let service: ViewItemsOverviewService
        let presenter: ViewItemsOverviewPresenting
        private var updateSubscriber: AnyCancellable?
        
        init(service: ViewItemsOverviewService,
             presenter: ViewItemsOverviewPresenting) {
            self.service = service
            self.presenter = presenter
            self.updateSubscriber = service.updatePublisher
                .receive(on: RunLoop.main)
                .sink { [self] _ in
                    handleRefresh()
                }
        }
        
        private func handleRefresh() {
            fetchItems()
        }
        
        func fetchItems() {
            do {
                let items = try service.fetchItems()
                presenter.presentFetch(items)
            } catch {
                presenter.present(error: error as? ServiceError)
            }
        }
        
        func didTapItem(with id: UUID) {
            service.prepareRouteToEditItem(with: id)
            presenter.presentShowEditItem()
        }
        
        func add() {
            service.prepareRouteToEditItem(with: nil)
            presenter.presentShowEditItem()
        }
    }
}
