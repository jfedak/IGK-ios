//
//  CategoryView.swift
//  Zadanie4
//
//  Created by Jakub Fedak on 18/12/2025.
//

import SwiftUI

struct CategoryView: View {
    @ObservedObject var category: Category

    var body: some View {
        NavigationStack {
            List(getProducts()) { product in
                NavigationLink {
                    ProductView(product: product)
                } label: {
                    Text(product.name!)
                }
            }
            .navigationTitle(category.name ?? "")
        }
    }
    
    private func getProducts() -> [Product] {
        let productsArray: [Product] = category.products!.allObjects as! [Product]
        return productsArray.sorted { $0.name! < $1.name! }
    }
}
