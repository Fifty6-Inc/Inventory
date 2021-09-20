//
//  ItemsGrid.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//

import SwiftUI

struct ItemsGrid: View {
    struct Item: Identifiable {
        let id: UUID
        let name: String
        let count: String
        let numberPerBuild: String?
    }
    let items: [Item]
    let didTapItem: (UUID) -> Void
    let didTapAdd: (() -> Void)?
    
    init(items: [Item],
         didTapItem: @escaping (UUID) -> Void,
         didTapAdd: (() -> Void)? = nil) {
        
        self.items = items
        self.didTapItem = didTapItem
        self.didTapAdd = didTapAdd
    }
    
    private let layout = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        LazyVGrid(columns: layout) {
            ForEach(items) { item in
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.appTintColor)
                    .inverseMask {
                        VStack {
                            Text(item.name)
                            Text(item.count)
                            if let numberPerBuild = item.numberPerBuild {
                                Text(numberPerBuild)
                            }
                        }
                    }
                    .frame(height: 150)
                    .onTapGesture {
                        didTapItem(item.id)
                    }
            }
            if let didTapAdd = didTapAdd {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.appTintColor)
                    .inverseMask {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(.largeTitle))
                    }
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.appTintColor)
                    .onTapGesture(perform: didTapAdd)
            }
        }
    }
}

struct ItemsGrid_Previews: PreviewProvider {
    static var previews: some View {
        ItemsGrid(
            items: [
                .init(id: UUID(), name: "Item 1", count: "1", numberPerBuild: "7"),
                .init(id: UUID(), name: "Item 2", count: "2", numberPerBuild: "1"),
                .init(id: UUID(), name: "Item 3", count: "3", numberPerBuild: "6"),
                .init(id: UUID(), name: "Item 4", count: "4", numberPerBuild: "5"),
                .init(id: UUID(), name: "Item 5", count: "5", numberPerBuild: "2"),
                .init(id: UUID(), name: "Item 6", count: "6", numberPerBuild: "3"),
                .init(id: UUID(), name: "Item 7", count: "7", numberPerBuild: "4"),
                .init(id: UUID(), name: "Item 8", count: "8", numberPerBuild: "8")
            ],
            didTapItem: { _ in },
            didTapAdd: { }
        )
    }
}
