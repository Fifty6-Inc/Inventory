//
//  ViewItemsOverviewService.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation

protocol ViewItemsOverviewService {
    func prepareRouteToEditItem()
}

extension ViewItemsOverview {
    
    enum ServiceError: Swift.Error {
        case saveFailed
    }
    
    class Service: ViewItemsOverviewService {
        func prepareRouteToEditItem() {
            EditItem.prepareIncomingRoute(with: nil)
        }
    }
    
    class PreviewService: ViewItemsOverviewService {
        func prepareRouteToEditItem() {
            EditItem.prepareIncomingRoute(with: nil)
        }
    }
}
