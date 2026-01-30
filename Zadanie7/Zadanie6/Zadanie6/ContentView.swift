//
//  ContentView.swift
//  Zadanie6
//
//  Created by Jakub Fedak on 30/01/2026.
//

import SwiftUI
import CoreData
internal import Combine

class ShoppingCartItems: ObservableObject {
    @Published var items: [Product: Int] = [:]
    
    func add(product: Product, quantity: Int) {
        items[product, default: 0] += quantity
    }
    
    func clear() {
        items.removeAll()
    }
    
    func getItems() -> [Product: Int] {
        return items
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
            
            OrderListView()
                .tabItem {
                    Label("Orders", systemImage: "cube.box.fill")
                }
        }
        .environmentObject(shoppingCartItems)
        .tint(.blue)
    }
}

