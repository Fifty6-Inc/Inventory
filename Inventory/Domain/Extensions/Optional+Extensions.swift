//
//  Optional+Extensions.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
