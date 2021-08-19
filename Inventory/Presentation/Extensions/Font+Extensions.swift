//
//  Font+Extensions.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

extension Font {
    init(name: String, size: CGFloat) {
        self.init(UIFont(name: name, size: size)!)
    }
}
