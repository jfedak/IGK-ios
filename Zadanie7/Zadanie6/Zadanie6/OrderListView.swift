//
//  OrderListView.swift
//  Zadanie4
//
//  Created by Jakub Fedak on 30/01/2026.
//

import SwiftUI

struct OrderListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Order.id, ascending: true)],
        animation: .default)
    private var orders: FetchedResults<Order>
    
    var body: some View {
        NavigationStack {
            List(orders) { order in
                NavigationLink {
                    OrderView(order: order)
                } label: {
                    Text("Order no. " + String(order.id))
                }
            }
            .navigationTitle("Orders")
            .accessibilityIdentifier("ordersList")
        }
    }
}
