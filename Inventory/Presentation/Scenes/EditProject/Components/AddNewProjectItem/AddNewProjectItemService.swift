//
//  AddNewProjectItemService.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation

protocol AddNewProjectItemService {
    func validateName(_ value: String) throws
    func validateCount(_ value: String) throws
    func validateNumberPerBuild(_ value: String) throws
    func canSave() -> Bool
    func save() throws
}

extension AddNewProjectItem {
    
    enum ServiceError: Swift.Error {
        case saveFailed
    }
    
    enum ValidationError: Swift.Error {
        case empty
        case invalid
    }
    
    struct ItemInfo {
        var name: String
        var count: Int
        var numberRequiredPerBuild: Int
    }
    
    class Service: AddNewProjectItemService {
        private let onSave: (ItemInfo) -> Void
        init(onSave: @escaping (ItemInfo) -> Void) {
            self.onSave = onSave
        }
        private var name: String?
        private var count: Int?
        private var numberRequiredPerBuild: Int?
        
        func validateName(_ value: String) throws {
            name = value
            if value.isEmpty { throw ValidationError.empty }
        }
        
        func validateCount(_ value: String) throws {
            count = Int(value)
            if value.isEmpty { throw ValidationError.empty }
            if count == nil { throw ValidationError.invalid }
        }
        
        func validateNumberPerBuild(_ value: String) throws {
            numberRequiredPerBuild = Int(value)
            if value.isEmpty { throw ValidationError.empty }
            if numberRequiredPerBuild == nil { throw ValidationError.invalid }
        }
        
        func canSave() -> Bool {
            !name.isNilOrEmpty && count != nil && count != nil
        }
        
        func save() throws {
            guard let name = name,
                  let count = count,
                  let numberRequiredPerBuild = numberRequiredPerBuild else { throw ServiceError.saveFailed }
            
            let itemInfo = ItemInfo(
                name: name,
                count: count,
                numberRequiredPerBuild: numberRequiredPerBuild)
            onSave(itemInfo)
        }
    }
    
    class PreviewService: AddNewProjectItemService {
        private var name = ""
        private var count: Int?
        private var numberPerBuild: Int?
        
        func validateName(_ value: String) throws {
            name = value
            if value.isEmpty { throw ValidationError.empty }
        }
        
        func validateCount(_ value: String) throws {
            count = Int(value)
            if value.isEmpty { throw ValidationError.empty }
            if count == nil { throw ValidationError.invalid }
        }
        
        func validateNumberPerBuild(_ value: String) throws {
            numberPerBuild = Int(value)
            if value.isEmpty { throw ValidationError.empty }
            if numberPerBuild == nil { throw ValidationError.invalid }
        }
        
        func canSave() -> Bool {
            !name.isEmpty && count != nil && count != nil
        }
        
        func save() throws {
            throw ServiceError.saveFailed
        }
    }
}
