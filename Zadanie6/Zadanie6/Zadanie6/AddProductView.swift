//
//  AddProductView.swift
//  Zadanie4
//
//  Created by Jakub Fedak on 30/01/2026.
//

import SwiftUI
import CoreData

struct AddProductView: View {
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var description: String = ""
    @State private var showAlert: Bool = false
    @State private var message: String = ""
    @State private var success: Bool = false
    
    @ObservedObject var category: Category
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("Product info") {
                TextField("Name", text: $name)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                TextField("Description", text: $description, axis: .vertical)
            }
        }
        .navigationTitle("Add new product")
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
                        await save()
                    }
                }
            }
        }
        .alert(success ? "Success" : "Error", isPresented: $showAlert) {
            Button("OK") {
                if success {
                    dismiss()
                }
                message = ""
            }
        } message: {
            Text(message)
        }
    }
    
    private func save() async -> Bool {
        print("saving")
        if name.isEmpty || price.isEmpty || description.isEmpty {
            message = "Please fill all the fields"
            showAlert = true
            return false
        }
        
        guard let priceDouble = Double(price), priceDouble > 0 else {
            message = "Price must be a positive number"
            showAlert = true
            return false
        }
        
        var id: Int64 = -1
        do {
            id = try await ServerService.addProduct(categoryId: category.id, name: name, price: priceDouble, description: description)
        } catch {
            print(error.localizedDescription)
            message = error.localizedDescription
            showAlert = true
            return false
        }
        
        let product = Product(context: viewContext)
        product.id = id
        product.category_id = Int64(category.id)
        product.name = name
        product.price = priceDouble
        product.desc = description
        product.category = category
        
        do {
            try viewContext.save()
        } catch {
            message = "Cannot update CoreData"
            showAlert = true
            return false
        }
        
        message = "Product added!"
        success = true
        showAlert = true
        return true
    }
}
