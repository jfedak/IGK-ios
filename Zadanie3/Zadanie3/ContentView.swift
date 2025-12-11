//
//  ContentView.swift
//  Zadanie3
//
//  Created by Jakub Fedak on 10/12/2025.
//

import SwiftUI
import CoreData
internal import Combine

class ShoppingCartItems: ObservableObject {
    @Published var items: [Product: Int] = [:]
    
    func add(product: Product, quantity: Int) {
        items[product, default: 0] += quantity
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var shoppingCartItems = ShoppingCartItems()
    
    var body: some View {
        TabView {
            CategoryListView()
                .tabItem {
                    Label("Store", systemImage: "storefront")
                }
            
            ShoppingCartView()
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
        }
        .environmentObject(shoppingCartItems)
        .tint(.blue)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
