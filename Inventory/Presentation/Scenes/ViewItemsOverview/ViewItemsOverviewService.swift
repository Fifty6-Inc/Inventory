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
    func allItems() throws -> [Item]
    
    var updatePublisher: RepositoryPublisher { get }
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
                    name: "Part 1",
                    count: 5),
                ItemDetails(
                    id: UUID(),
                    name: "Part 2",
                    count: 45433),
                ItemDetails(
                    id: UUID(),
                    name: "Part 3",
                    count: 0),
                ItemDetails(
                    id: UUID(),
                    name: "Part 4",
                    count: 3433),
                ItemDetails(
                    id: UUID(),
                    name: "Part 5",
                    count: 999999999)
            ]
        }
        
        func prepareRouteToEditItem(with id: UUID?) {
            EditItem.prepareIncomingRoute(with: id)
        }
    }
}
