//
//  ApplicationState.swift
//  Inventory
//
//  Created by Mikael Weiss on 9/22/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import Foundation

class ApplicationState {
    private init() {}
    static let shared = ApplicationState()
    
    var usePreviewServices = UserDefaults.standard.value(forKey: "usePreviewServices") as? Bool ?? false {
        willSet {
            UserDefaults.standard.set(newValue, forKey: "usePreviewServices")
        }
    }
}
