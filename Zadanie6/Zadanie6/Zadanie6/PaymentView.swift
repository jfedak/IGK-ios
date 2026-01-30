//
//  PaymentView.swift
//  Zadanie6
//
//  Created by Jakub Fedak on 30/01/2026.
//

import SwiftUI
import CoreData

struct PaymentView: View {
    @EnvironmentObject var shoppingCartItems: ShoppingCartItems
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var cardNumber: String = ""
    @State private var expiryMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var expiryYear: Int = Calendar.current.component(.year, from: Date())
    @State private var cvv: String = ""
    @State private var showAlert: Bool = false
    @State private var message: String = ""
    @State private var success: Bool = false
    
    private let months = Array(1...12)
    private let year = Calendar.current.component(.year, from: Date())
    private var availableYears: [Int] {
        return (year...(year + 6)).map { $0 }
    }
    
    var body: some View {
        Form {
            Section("Fill your credit card info") {
                TextField("Card number: ", text: $cardNumber)
                    .keyboardType(.decimalPad)
                HStack {
                    Text("Expiry date: ")
                    Picker("Month", selection: $expiryMonth) {
                        ForEach(months, id: \.self) { month in
                            Text(String(format: "%02d", month)).tag(month)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .fixedSize()
                    
                    Text("/")
                    
                    Picker("Year", selection: $expiryYear) {
                        ForEach(availableYears, id: \.self) { year in
                            Text(String(year % 100)).tag(year)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .fixedSize()
                    
                    Spacer()
                }
                TextField("CVV", text: $cvv)
                    .keyboardType(.decimalPad)
            }
        }
        .navigationTitle("Payment info")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    Task {
                        await paymentToServer()
                    }
                }
            }
        }
        .alert(success ? "Success" : "Error", isPresented: $showAlert) {
            Button("OK") {
                if success {
                    shoppingCartItems.clear()
                    dismiss()
                }
                message = ""
            }
        } message: {
            Text(message)
        }
    }
    
    private func paymentToServer() async -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let productRequest: NSFetchRequest<Product> = Product.fetchRequest()
        var productMap: [Int64: Product] = [:]
        do {
            let allProducts = try viewContext.fetch(productRequest)
            for product in allProducts {
                productMap[product.id] = product
            }
        } catch {
            showMessage("Cannot fetch products from CoreData before adding new order")
            return false
        }
        
        let (isCardValid, cardNumberNoSpaces) = verifyCardNumber()
        let (isCVVValid, cvvNoSpaces) = verifyCVV()
        
        guard isCardValid else {
            showMessage("Incorrect card number")
            return false
        }
        
        guard isCVVValid else {
            showMessage("Incorrect cvv number")
            return false
        }
        
        var result: AddOrderResponse
        do {
            let expirationDate = String(format: "%02d/%02d", expiryMonth, expiryYear % 100)
            result = try await ServerService.addOrder(products: shoppingCartItems.getItems(), cardNumber: cardNumberNoSpaces, expirationDate: expirationDate, cvv: cvvNoSpaces)
        } catch {
            showMessage(error.localizedDescription)
            return false
        }
        
        let order = Order(context: viewContext)
        order.id = result.order_id
        order.date = formatter.date(from: result.date)
        order.status = result.status
        order.total_price = result.total_price
        
        let sortedPairs = shoppingCartItems.getItems().sorted { $0.key.name! < $1.key.name! }
        
        for (product, quantity) in sortedPairs {
            let orderItem = OrderItem(context: viewContext)
            orderItem.order = order
            orderItem.product = product
            orderItem.quantity = Int64(quantity)
        }
        
        do {
            try viewContext.save()
        } catch {
            showMessage("Cannot save new order to CoreData")
            return false
        }
        
        showMessage("Your order has been placed successfully!")
        success = true
        return true
    }
    
    private func verifyCardNumber() -> (Bool, String) {
        let numberNoSpaces = cardNumber.replacingOccurrences(of: " ", with: "")
        guard !numberNoSpaces.isEmpty else { return (false, numberNoSpaces) }
        let isNumeric = numberNoSpaces.allSatisfy { $0.isNumber }
        return (isNumeric && numberNoSpaces.count == 16, numberNoSpaces)
    }
    
    private func verifyCVV() -> (Bool, String) {
        let cvvNoSpaces = cvv.replacingOccurrences(of: " ", with: "")
        guard !cvvNoSpaces.isEmpty else { return (false, cvvNoSpaces) }
        let isNumeric = cvvNoSpaces.allSatisfy { $0.isNumber }
        return (isNumeric && cvvNoSpaces.count == 3, cvvNoSpaces)
    }
    
    private func showMessage(_ message: String) {
        self.message = message
        showAlert = true
    }
}

