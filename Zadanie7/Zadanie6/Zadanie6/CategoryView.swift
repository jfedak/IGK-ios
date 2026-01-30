//
//  CategoryView.swift
//  Zadanie4
//
//  Created by Jakub Fedak on 18/12/2025.
//

import SwiftUI

struct CategoryView: View {
    @ObservedObject var category: Category
    @FetchRequest var products: FetchedResults<Product>
    @State private var isPresented: Bool = false
    
    init(category: Category) {
        self.category = category
        _products = FetchRequest(
                    sortDescriptors: [SortDescriptor(\.name, order: .forward)],
                    predicate: NSPredicate(format: "category == %@", category),
                    animation: .default)
    }

    var body: some View {
        NavigationStack {
            List{
                ForEach(products) { product in
                    NavigationLink {
                        ProductView(product: product)
                    } label: {
                        Text(product.name!)
                    }
                }
            }
            .navigationTitle(category.name ?? "")
            .accessibilityIdentifier("productsList")
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Add", systemImage: "plus") {
                    isPresented = true
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack{
                AddProductView(category: category)
            }
        }
    }
}


