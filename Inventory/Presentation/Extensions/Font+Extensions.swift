//
//  Font+Extensions.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//

import SwiftUI

extension Font {
    init(name: String, size: CGFloat) {
        self.init(UIFont(name: name, size: size)!)
    }
}
