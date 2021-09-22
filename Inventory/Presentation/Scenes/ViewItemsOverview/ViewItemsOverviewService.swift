//
//  ViewItemsOverviewService.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation

protocol ViewItemsOverviewService {
    var updatePublisher: RepositoryPublisher { get }
    func fetchItems() throws -> [ViewItemsOverview.ItemDetails]
    func prepareRouteToEditItem(with id: UUID?)
}

protocol ViewItemsOverviewFetching {
    var updatePublisher: RepositoryPublisher { get }
    func allItems() throws -> [Item]
}
extension MainItemRepository: ViewItemsOverviewFetching { }

extension ViewItemsOverview {
    
    enum ServiceError: Swift.Error {
        case fetchFailed
    }
    
    struct ItemDetails {
        let id: UUID
        let name: String
        let count: Int
    }
    
    class Service: ViewItemsOverviewService {
        private let itemFetcher: ViewItemsOverviewFetching
        
        var updatePublisher: RepositoryPublisher {
            itemFetcher.updatePublisher.eraseToAnyPublisher()
        }
        
        init(itemFetcher: ViewItemsOverviewFetching) {
            self.itemFetcher = itemFetcher
        }
        
        func fetchItems() throws -> [ItemDetails] {
            do {
                let items = try itemFetcher.allItems()
                let itemDetails = items.map {
                    ItemDetails(
                        id: $0.id,
                        name: $0.name,
                        count: $0.count)
                }
                return itemDetails
            } catch {
                throw ServiceError.fetchFailed
            }
        }
        
        func prepareRouteToEditItem(with id: UUID?) {
            EditItem.prepareIncomingRoute(with: id)
        }
    }
    
    class PreviewService: ViewItemsOverviewService {
        
        var updatePublisher: RepositoryPublisher = RepositorySubject().eraseToAnyPublisher()
        
        func fetchItems() throws -> [ItemDetails] {
            [
                ItemDetails(
                    id: UUID(),
                    name: "Takedown Pins",
                    count: 10),
                ItemDetails(
                    id: UUID(),
                    name: "K25 Springs",
                    count: 3),
                ItemDetails(
                    id: UUID(),
                    name: "Extension Springs",
                    count: 2),
                ItemDetails(
                    id: UUID(),
                    name: "10-32 Threaded Rods",
                    count: 4),
                ItemDetails(
                    id: UUID(),
                    name: "10-32 Hex Nuts",
                    count: 15)
            ]
        }
        
        func prepareRouteToEditItem(with id: UUID?) {
            EditItem.prepareIncomingRoute(with: id)
        }
    }
}
