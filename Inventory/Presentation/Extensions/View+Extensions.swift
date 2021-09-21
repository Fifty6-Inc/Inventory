//
//  View+Extensions.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
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
    func inverseMask<M: View>(_ mask: () -> M) -> some View {
        ZStack {
            self
            mask()
                .blendMode(.destinationOut)
        }.compositingGroup()
    }
}

extension View {
    /// Used to make link navigation read like sheet navigation
    func navLink<Destination: View>(isActive: Binding<Bool>, destination: @escaping () -> Destination) -> some View {
        ZStack {
            self
            NavigationLink(destination: LazyView(destination()), isActive: isActive, label: { EmptyView() })
        }
    }
}
/// Used to fix issue where view inside NavigationLink is initilized before the link is clicked on
/// See more [here](https://stackoverflow.com/questions/57594159/swiftui-navigationlink-loads-destination-view-immediately-without-clicking)
private struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

extension View {
    func gradientNavBar() -> some View {
        GeometryReader { geo in
            ZStack {
                self
                LinearGradient(
                    gradient: Gradient(colors: [.appBackground, .appBackground.opacity(0)]),
                    startPoint: .top,
                    endPoint: .bottom)
                    .frame(height: geo.safeAreaInsets.top + 15)
                    .position(x: geo.frame(in: .global).midX, y: 15)
                    .ignoresSafeArea()
            }
        }
    }
}
