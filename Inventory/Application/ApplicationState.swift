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
    
    private(set) var usePreviewServices = UserDefaults.standard.value(forKey: "usePreviewServices") as? Bool ?? false
    func set(usePreviewServices: Bool) {
        #if DEBUG
        UserDefaults.standard.set(usePreviewServices, forKey: "usePreviewServices")
        #endif
    }
}
