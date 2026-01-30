//
//  Zadanie4App.swift
//  Zadanie4
//
//  Created by Jakub Fedak on 18/12/2025.
//

import SwiftUI
import CoreData

struct ProductJSON: Decodable {
    let id: Int64
    let category_id: Int64
    let name: String
    let price: Double
    let description: String
}

struct CategoryJSON: Decodable {
    let id: Int64
    let name: String
}

struct OrderJSON: Decodable {
    let order_id: Int64
    let date: String
    let products: [Int64]
    let quantity: [Int64]
    let total_price: Double
    let status: String
}



@main
struct Zadanie4App: App {
    let persistenceController = PersistenceController.shared

    init() {
        let viewContext = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = OrderItem.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        do {
            let result = try viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
            
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                let changes = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [viewContext])
            }
            
        } catch {
            print("Error while deleting orderItems: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .task {
                    await loadCategoryToCoreDataAsync()
                    await loadProductsToCoreDataAsync()
                    await loadOrderstoCoreDataAsync()
                }
        }
    }
    
    private func loadCategoryToCoreDataAsync() async {
        guard let url = URL(string: "http://127.0.0.1:8000/categories") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([CategoryJSON].self, from: data)
            
            for categoryData in decodedData {
                let coreDataCategory = Category(context: persistenceController.container.viewContext)
                coreDataCategory.id = categoryData.id
                coreDataCategory.name = categoryData.name
//                print(categoryData.id, categoryData.name)
            }
            
            try persistenceController.container.viewContext.save()
        } catch {
            print("Cannot fetch categories")
            return
        }
    }
    
    private func loadProductsToCoreDataAsync() async {
        let context = persistenceController.container.viewContext
        let categoryRequest: NSFetchRequest<Category> = Category.fetchRequest()
        var categoryMap: [Int64: Category] = [:]
        do {
            let allCategories = try context.fetch(categoryRequest)
//            var categoryMap: [Int64: Category] = [:]
            for category in allCategories {
                print("aaa")
                categoryMap[category.id] = category
            }
        } catch {
            print("Cannot fetch categories from CoreData before fetching products from server")
            return
        }
        
//        print(categoryMap.count)
        guard let url = URL(string: "http://127.0.0.1:8000/products") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([ProductJSON].self, from: data)
            
            for productData in decodedData {
                let coreDataProduct = Product(context: persistenceController.container.viewContext)
                coreDataProduct.id = productData.id
                coreDataProduct.name = productData.name
                coreDataProduct.price = productData.price
                coreDataProduct.desc = productData.description
                coreDataProduct.category = categoryMap[productData.category_id]
                
//                print(categoryMap[productData.category_id]!)
//                
//                print(productData.id, productData.name, productData.price, productData.category_id)
            }
            
//            print("")
//            print("")
//            print("")
            
            try persistenceController.container.viewContext.save()
        } catch {
            print("Cannot fetch products")
            print(error.localizedDescription)
            return
        }
    }
    
    private func loadOrderstoCoreDataAsync() async {
        print("start fetching orders")
        let context = persistenceController.container.viewContext
        let productRequest: NSFetchRequest<Product> = Product.fetchRequest()
        var productMap: [Int64: Product] = [:]
        do {
            let allProducts = try context.fetch(productRequest)
            for product in allProducts {
                productMap[product.id] = product
            }
        } catch {
            print("Cannot fetch products from CoreData before fetching orders from server")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        
        guard let url = URL(string: "http://127.0.0.1:8000/orders") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([OrderJSON].self, from: data)
            
            for orderData in decodedData {
                let coreDataOrder = Order(context: persistenceController.container.viewContext)
                coreDataOrder.id = orderData.order_id
                coreDataOrder.date = formatter.date(from: orderData.date)
                coreDataOrder.status = orderData.status
                coreDataOrder.total_price = orderData.total_price
                
                for (product_id, quantity) in zip(orderData.products, orderData.quantity) {
                    let coreDataOrderItem = OrderItem(context: persistenceController.container.viewContext)
                    coreDataOrderItem.quantity = quantity
                    coreDataOrderItem.order = coreDataOrder
                    coreDataOrderItem.product = productMap[product_id]!
                }
                
                print(coreDataOrder)
            }
            
            
            
            try persistenceController.container.viewContext.save()
        } catch {
            print("Cannot fetch orders")
            print(error)
            print(error.localizedDescription)
            return
        }
    }
}

