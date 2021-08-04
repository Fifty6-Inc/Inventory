//
//  ViewProjectsOverviewService.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

protocol ViewProjectsOverviewService {
    var updatePublisher: RepositoryPublisher { get }
    func fetchItems() throws -> [ViewProjectsOverview.ItemDetails]
    func prepareRouteToEditItem(with id: UUID?)
}

protocol ViewProjectsOverviewFetching {
    func allItems() throws -> [Item]
    
    var updatePublisher: RepositoryPublisher { get }
}
extension MainItemRepository: ViewProjectsOverviewFetching { }

extension ViewProjectsOverview {
    
    enum ServiceError: Swift.Error {
        case fetchFailed
    }
    
    struct ItemDetails: Identifiable {
        let id: UUID
        let name: String
        let count: Int
    }
    
    class Service: ViewProjectsOverviewService {
        private let itemFetcher: ViewProjectsOverviewFetching
        
        var updatePublisher: RepositoryPublisher {
            itemFetcher.updatePublisher.eraseToAnyPublisher()
        }
        
        init(itemFetcher: ViewProjectsOverviewFetching) {
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
    
    class PreviewService: ViewProjectsOverviewService {
        
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
