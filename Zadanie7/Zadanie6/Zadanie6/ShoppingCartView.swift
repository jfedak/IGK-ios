//
//  ShoppingCartView.swift
//  Zadanie4
//
//  Created by Jakub Fedak on 18/12/2025.
//

import SwiftUI

struct ShoppingCartView: View {
    @EnvironmentObject var shoppingCartItems: ShoppingCartItems
    @State private var isPresented: Bool = false
    
    var body: some View {
        let sortedKeys = shoppingCartItems.items.keys.sorted { $0.name! < $1.name! }
        
        VStack {
            if sortedKeys.isEmpty {
                Text("Your cart is empty")
            } else {
                List(sortedKeys) {key in
                    HStack {
                        Text(key.name ?? "")
                        Spacer()
                        Text("x\(shoppingCartItems.items[key]!)")
                    }
                }
                .navigationTitle("Shopping Cart")
                if !sortedKeys.isEmpty {
                    Button("Proceed to checkout") {
                        isPresented = true
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                PaymentView()
            }
        }
    }
}

