//
//  ProjectsGrid.swift
//  Inventory
//
//  Created by Mikael Weiss on 9/20/21.
//

import SwiftUI

struct ProjectsGrid: View {
    struct Project: Identifiable {
        let id: UUID
        let name: String
    }
    let projects: [Project]
    let didTapProject: (UUID) -> Void
    
    init(projects: [Project],
         didTapProject: @escaping (UUID) -> Void) {
        
        self.projects = projects
        self.didTapProject = didTapProject
    }
    
    private let layout = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        LazyVGrid(columns: layout) {
            ForEach(projects) { item in
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.appTintColor)
                    .inverseMask {
                        Text(item.name)
                    }
                    .frame(height: 150)
                    .onTapGesture {
                        didTapProject(item.id)
                    }
            }
        }
    }
}

struct ProjectsGrid_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsGrid(
            projects: [
                .init(id: UUID(), name: "Item 1"),
                .init(id: UUID(), name: "Item 2"),
                .init(id: UUID(), name: "Item 3"),
                .init(id: UUID(), name: "Item 4"),
                .init(id: UUID(), name: "Item 5"),
                .init(id: UUID(), name: "Item 6"),
                .init(id: UUID(), name: "Item 7"),
                .init(id: UUID(), name: "Item 8")
            ],
            didTapProject: { _ in })
    }
}
