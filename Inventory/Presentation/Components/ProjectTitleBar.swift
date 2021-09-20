//
//  ProjectTitleBar.swift
//  Inventory
//
//  Created by Mikael Weiss on 9/20/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
//

import SwiftUI

struct ProjectTitleBar: View {
    let title: String
    let onBack: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: 34, weight: .bold, design: .rounded))
            
            HStack {
                backButton
                Spacer()
                editButton
            }
        }
        .padding([.top, .horizontal], 20)
        .navigationBarHidden(true)
    }
    
    var backButton: some View {
        Button(action: onBack) {
            Image(systemName: "arrow.left")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .contentShape(Rectangle())
                .accentColor(.appTintColor)
        }
    }
    
    var editButton: some View {
        Button(action: onEdit) {
            Text("Edit")
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .accentColor(.appTintColor)
        }
    }
}

struct ProjectTitleBar_Previews: PreviewProvider {
    static var previews: some View {
        ProjectTitleBar(
            title: "Some Project",
            onBack: {},
            onEdit: {})
    }
}
