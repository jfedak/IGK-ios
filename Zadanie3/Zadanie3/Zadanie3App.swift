//
//  Zadanie3App.swift
//  Zadanie3
//
//  Created by Jakub Fedak on 10/12/2025.
//

import SwiftUI
import CoreData

@main
struct Zadanie3App: App {
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
        
        
        let initialData: [[String: Any]] = [
            [
                "category": "Shoes",
                "products": [
                    [
                        "name": "CloudRunner Elite",
                        "price": 129.99,
                        "description": "Lightweight running shoes designed for maximum energy return and marathon endurance."
                    ],
                    [
                        "name": "Urban Trekker Boots",
                        "price": 145.00,
                        "description": "Durable leather boots with slip-resistant soles, perfect for city streets and light trails."
                    ],
                    [
                        "name": "Canvas Classic Lo",
                        "price": 45.50,
                        "description": "Timeless low-top canvas sneakers suitable for everyday casual wear in any season."
                    ]
                ]
            ],
            [
                "category": "T-shirts",
                "products": [
                    [
                        "name": "Vintage Logo Tee",
                        "price": 24.99,
                        "description": "Soft organic cotton blend featuring a distressed retro-style brand graphic."
                    ],
                    [
                        "name": "Pro-Active Fit",
                        "price": 35.00,
                        "description": "Moisture-wicking athletic top designed to keep you cool during intense workouts."
                    ],
                    [
                        "name": "Essential Heavyweight",
                        "price": 18.00,
                        "description": "A premium heavyweight cotton t-shirt with a boxy fit that goes with everything."
                    ]
                ]
            ],
            [
                "category": "Hoodies",
                "products": [
                    [
                        "name": "Cozy Fleece Pullover",
                        "price": 55.00,
                        "description": "Oversized fit hoodie lined with brushed fleece and a spacious kangaroo pocket."
                    ],
                    [
                        "name": "Streetwear Zip-Up",
                        "price": 72.50,
                        "description": "Modern slim-fit zip hoodie featuring reinforced stitching and metal hardware."
                    ],
                    [
                        "name": "Tech-Knit Hoodie",
                        "price": 85.00,
                        "description": "Breathable and stretchable hoodie designed specifically for active lifestyles and travel."
                    ]
                ]
            ],
            [
                "category": "Jackets",
                "products": [
                    [
                        "name": "Midnight Bomber",
                        "price": 110.00,
                        "description": "Classic silhouette bomber jacket featuring a water-resistant nylon shell and ribbed cuffs."
                    ],
                    [
                        "name": "Alpine Windbreaker",
                        "price": 95.00,
                        "description": "Ultra-lightweight shell jacket that packs down into its own pocket for easy storage."
                    ],
                    [
                        "name": "Denim Sherpa Coat",
                        "price": 130.00,
                        "description": "Rugged indigo denim jacket lined with warm faux sherpa for cooler autumn days."
                    ]
                ]
            ]
        ]
        
        
        for categoryData in initialData {
            let coreDataCategory = Category(context: persistenceController.container.viewContext)
            coreDataCategory.name = categoryData["category"] as? String ?? ""

            if let products = categoryData["products"] as? [[String: Any]] {
                for productData in products {
                    let coreDataProduct = Product(context: persistenceController.container.viewContext)
                    coreDataProduct.name = productData["name"] as? String ?? ""
                    coreDataProduct.price = productData["price"] as? Double ?? 0.0
                    coreDataProduct.desc = productData["description"] as? String ?? ""
                    coreDataProduct.category = coreDataCategory
                }
            }
        }

        do {
            try persistenceController.container.viewContext.save()
            print("Data saved successfully")
        } catch {
            print("Initialization of CoreData failed with error: \(error)")
        }
    }
}

