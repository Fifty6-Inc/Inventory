//
//  ViewItemsOverviewService.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ViewItemsOverviewService {
    func validateText(_ value: String) throws
    func canSave() -> Bool
    func save() throws
}

extension ViewItemsOverview {
    
    enum ServiceError: Swift.Error {
        case saveFailed
    }
    
    enum ValidationError: Swift.Error {
        case empty
        case invalid
    }
    
    class Service: ViewItemsOverviewService {
        private var text: String?
        
        func validateText(_ value: String) throws {
            if value.isEmpty { throw ValidationError.empty }
            text = value
        }
        
        func canSave() -> Bool {
            guard let text = text else { return false }
            return !text.isEmpty
        }
        
        func save() throws {
            throw ServiceError.saveFailed
        }
    }
    
    class PreviewService: ViewItemsOverviewService {
        private var text: String?
        
        func validateText(_ value: String) throws {
            if value.isEmpty { throw ValidationError.empty }
            text = value
        }
        
        func canSave() -> Bool {
            guard let text = text else { return false }
            return !text.isEmpty
        }
        
        func save() throws {
            throw ServiceError.saveFailed
        }
    }
}
