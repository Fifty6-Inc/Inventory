//
//  View+Extensions.swift
//  Inventory
//
//  Created by Mikael Weiss on 5/8/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import SwiftUI

extension View {
    /// Used when you want to have a conditional modifier
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
    
    /// Used when you want to use conditional setup with if-else
    @ViewBuilder
    func `if`<Content: View, ContentElse: View>(_ condition: Bool, content: (Self) -> Content, else: (Self) -> ContentElse) -> some View {
        if condition {
            content(self)
        } else {
            `else`(self)
        }
    }
}

extension View {
    /// Used to provide an inverse masking
    public func inverseMask<M: View>(_ mask: () -> M) -> some View {
        ZStack {
            self
            mask()
                .blendMode(.destinationOut)
        }.compositingGroup()
    }
}
