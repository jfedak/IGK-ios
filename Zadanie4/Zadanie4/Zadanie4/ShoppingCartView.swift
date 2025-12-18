//
//  ShoppingCartView.swift
//  Zadanie4
//
//  Created by Jakub Fedak on 18/12/2025.
//

import SwiftUI

struct ShoppingCartView: View {
    @EnvironmentObject var shoppingCartItems: ShoppingCartItems
    
    var body: some View {
        let sortedKeys = shoppingCartItems.items.keys.sorted { $0.name! < $1.name! }
        
        List(sortedKeys) {key in
            HStack {
                Text(key.name ?? "")
                Spacer()
                Text("x\(shoppingCartItems.items[key]!)")
            }
        }
        .navigationTitle("Shopping Cart")
    }
}

