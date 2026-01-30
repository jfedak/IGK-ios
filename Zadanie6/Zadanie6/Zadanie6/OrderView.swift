//
//  OrderView.swift
//  Zadanie4
//
//  Created by Jakub Fedak on 30/01/2026.
//

import SwiftUI

struct OrderView: View {
    @ObservedObject var order: Order
//    @FetchRequest var products: FetchedResults<Product>

    var body: some View {
        Text("Order no. " + String(order.id))
        Text("Date: " + (order.date?.formatted(date: .numeric, time: .omitted))!)
        Text("Total price: " + String(format: "%.2f", order.total_price))
        Text("Status: " + order.status!)
        
        Section("") {
            List(getItems()) { item in
                HStack {
                    Text(item.product?.name ?? "")
                    Spacer()
                    Text("\(item.quantity) x \(String(item.product?.price ?? 0.0))")
                }
            }
        }
    }
    
    private func getItems() -> [OrderItem] {
        let set = order.items as? Set<OrderItem> ?? []
         
        return set.sorted {
            ($0.product?.name ?? "") < ($1.product?.name ?? "")
        }
    }
}
