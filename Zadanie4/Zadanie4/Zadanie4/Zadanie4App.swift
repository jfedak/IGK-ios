//
//  Zadanie4App.swift
//  Zadanie4
//
//  Created by Jakub Fedak on 18/12/2025.
//

import SwiftUI
import CoreData

struct ProductJSON: Decodable {
    let name: String
    let price: Double
    let description: String
}

struct CategoryJSON: Decodable {
    let category: String
    let products: [ProductJSON]
}

@main
struct Zadanie4App: App {
    let persistenceController = PersistenceController.shared

    init() {
        loadToCoreData()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    private func loadToCoreData() {
        let request = NSFetchRequest<Category>(entityName: "Category")
        
        do {
            let categories = try persistenceController.container.viewContext.fetch(request)
            if !categories.isEmpty {
                return
            }
        } catch { }
        
        guard let url = URL(string: "http://127.0.0.1:8000/products") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else { return }
            
            do {
                let decodedData = try JSONDecoder().decode([CategoryJSON].self, from: data)
                
                for categoryData in decodedData {
                    let coreDataCategory = Category(context: persistenceController.container.viewContext)
                    coreDataCategory.name = categoryData.category
                    
                    for productData in categoryData.products {
                        let coreDataProduct = Product(context: persistenceController.container.viewContext)
                        coreDataProduct.name = productData.name
                        coreDataProduct.price = productData.price
                        coreDataProduct.desc = productData.description
                        coreDataProduct.category = coreDataCategory
                    }
                }
                
                try persistenceController.container.viewContext.save()
            } catch {
                print("error \(error)")
                return
            }
        }.resume()
    }
}
