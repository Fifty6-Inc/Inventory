//
//  ItemsGrid.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/4/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
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
                    .overlay(
                        VStack(alignment: .leading, spacing: 5) {
                            Text(item.name)
                                .font(.title)
                            Text(item.count)
                                .font(.headline)
                            if let numberPerBuild = item.numberPerBuild {
                                Text(numberPerBuild)
                            }
                        }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.appWhite)
                            .lineLimit(2)
                            .padding(.horizontal)
                    )
                    .frame(height: 150)
                    .onTapGesture {
                        didTapItem(item.id)
                    }
            }
            if let didTapAdd = didTapAdd {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.appTintColor)
                    .overlay(
                        Image(systemName: "plus")
                            .font(.system(.largeTitle))
                            .foregroundColor(.appWhite)
                            .padding()
                    )
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
        ScrollView {
            ItemsGrid(
                items: [
                    .init(id: UUID(), name: "Extension Springs", count: "1", numberPerBuild: "7"),
                    .init(id: UUID(), name: "K25 Springs", count: "2", numberPerBuild: "1"),
                    .init(id: UUID(), name: "Takedown Pins", count: "3", numberPerBuild: "6"),
                    .init(id: UUID(), name: "10-32 Threaded Rods", count: "4", numberPerBuild: "5"),
                    .init(id: UUID(), name: "10-32 Hex Nuts", count: "5", numberPerBuild: "2"),
                    .init(id: UUID(), name: "10-32 1/8th inch rounded head screws", count: "6", numberPerBuild: "3"),
                    .init(id: UUID(), name: "Item 7", count: "7", numberPerBuild: "4"),
                    .init(id: UUID(), name: "Item 8", count: "8", numberPerBuild: "8")
                ],
                didTapItem: { _ in },
                didTapAdd: { }
            ).padding(.horizontal)
        }
    }
}
