//
//  EditItemService.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol EditItemService {
    func validateName(_ value: String) throws
    func validateCount(_ value: String) throws
    func canSave() -> Bool
    func save() throws
}

extension EditItem {
    
    enum ServiceError: Swift.Error {
        case saveFailed
    }
    
    enum ValidationError: Swift.Error {
        case empty
        case invalid
    }
    
    class Service: EditItemService {
        private var name = ""
        private var count: Int?
        
        func validateName(_ value: String) throws {
            name = value
            if value.isEmpty { throw ValidationError.empty }
        }
        
        func validateCount(_ value: String) throws {
            count = Int(value)
            if value.isEmpty { throw ValidationError.empty }
            if count == nil { throw ValidationError.invalid }
        }
        
        func canSave() -> Bool {
            !name.isEmpty && count != nil
        }
        
        func save() throws {
            throw ServiceError.saveFailed
        }
    }
    
    class PreviewService: EditItemService {
        private var name = ""
        private var count: Int?
        
        func validateName(_ value: String) throws {
            name = value
            if value.isEmpty { throw ValidationError.empty }
        }
        
        func validateCount(_ value: String) throws {
            count = Int(value)
            if value.isEmpty { throw ValidationError.empty }
            if count == nil { throw ValidationError.invalid }
        }
        
        func canSave() -> Bool {
            !name.isEmpty && count != nil
        }
        
        func save() throws {
            throw ServiceError.saveFailed
        }
    }
}
