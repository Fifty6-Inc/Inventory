//
//  UINavigationController+Extensions.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/10/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
