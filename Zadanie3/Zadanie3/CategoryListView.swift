//
//  CategoryListView.swift
//  Zadanie3
//
//  Created by Jakub Fedak on 10/12/2025.
//

import SwiftUI

struct CategoryListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>
    
    var body: some View {
        NavigationStack {
            List(categories) { category in
                NavigationLink {
                    CategoryView(category: category)
                } label: {
                    Text(category.name ?? "")
                }
            }
            .navigationTitle("Categories")
        }
    }
}

