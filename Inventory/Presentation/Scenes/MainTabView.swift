//
//  MainTabView.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

private enum Tabs: Hashable {
    case itemsView
    case projectsView
}

struct MainTabView: View {
    @State private var selectedTab = Tabs.itemsView
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ViewItemsOverview.Scene().view()
                .tabItem {
                    Image(systemName: "square.3.stack.3d")
                    Text("Items")
                }.tag(Tabs.itemsView)
            ViewProjectsOverview.Scene().view()
                .tabItem {
                    Image(systemName: "square.stack.3d.up")
                    Text("Projects")
                }.tag(Tabs.projectsView)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
