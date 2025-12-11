//
//  ProductView.swift
//  Zadanie3
//
//  Created by Jakub Fedak on 10/12/2025.
//

import SwiftUI
import CoreData

struct ProductView: View {
    @ObservedObject var product: Product
    @EnvironmentObject var shoppingCartItems: ShoppingCartItems
    @State private var quantity: Int = 1
    @State private var showMessage: Bool = false

    var body: some View {
        Text(product.name ?? "Unnamed product")
            .font(.largeTitle)
            .padding(10)
            
        Text("Price: " + String(format: "%.2f", product.price) + "$")
            .font(.title)
            .padding(10)
        
        Text(product.desc ?? "")
            .padding(40)
            
        
        HStack{
            Text("Quantity: \(quantity)")
            Stepper("", value: $quantity, in: 1...1000)
                .labelsHidden()
            Spacer()
            
            Button {
                shoppingCartItems.add(product: product, quantity: quantity)
                quantity = 1
                showMessage = true
            } label: {
                Text("Add to cart")
            }
        }
        .padding(40)
        
        Text("Product added to cart")
            .foregroundStyle(showMessage ? .black : .clear)
    }
}
