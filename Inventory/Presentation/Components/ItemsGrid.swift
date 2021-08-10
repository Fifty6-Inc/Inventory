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
                        }
                    }
                    .frame(height: 150)
                    .onTapGesture {
                        didTapItem(item.id)
                    }
            }
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.appTintColor)
                .inverseMask {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(.largeTitle))
                }
                .frame(height: 150)
                .frame(maxWidth: .infinity)
                .foregroundColor(.appTintColor)
                .onTapGesture(perform: didTapAdd ?? {})
                .if(didTapAdd == nil) {
                    $0.hidden()
                }
        }
    }
}

struct ItemsGrid_Previews: PreviewProvider {
    static var previews: some View {
        ItemsGrid(
            items: [
                .init(id: UUID(), name: "Item 1", count: "1"),
                .init(id: UUID(), name: "Item 2", count: "2"),
                .init(id: UUID(), name: "Item 3", count: "3"),
                .init(id: UUID(), name: "Item 4", count: "4"),
                .init(id: UUID(), name: "Item 5", count: "5"),
                .init(id: UUID(), name: "Item 6", count: "6"),
                .init(id: UUID(), name: "Item 7", count: "7"),
                .init(id: UUID(), name: "Item 8", count: "8")
            ],
            didTapItem: { _ in },
            didTapAdd: { }
        )
    }
}
