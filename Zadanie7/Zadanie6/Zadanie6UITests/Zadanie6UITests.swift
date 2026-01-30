//
//  Zadanie6UITests.swift
//  Zadanie6UITests
//
//  Created by Jakub Fedak on 30/01/2026.
//

import XCTest
import CoreData
@testable import Zadanie6

final class Zadanie6UITests: XCTestCase {
    
    var context: NSManagedObjectContext!
    var controller: PersistenceController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        controller = PersistenceController(inMemory: true)
        context = controller.container.viewContext
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        context = nil
        controller = nil
    }
    
    @MainActor
    func testMainScreen() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars.element
        XCTAssertTrue(tabBar.exists)
        XCTAssertEqual(tabBar.buttons.count, 3)
        
        let storeTab = tabBar.buttons["Store"]
        XCTAssertTrue(storeTab.exists)
        
        let cardTab = tabBar.buttons["Cart"]
        XCTAssertTrue(cardTab.exists)
        
        let ordersTab = tabBar.buttons["Orders"]
        XCTAssertTrue(ordersTab.exists)
    }
    
    
    func testEmptyCardScreen() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars.element
        let cardTab = tabBar.buttons["Cart"]
        cardTab.tap()
        
        let text = app.staticTexts["Your cart is empty"]
        XCTAssertTrue(text.exists)
        
        let button = app.buttons["Proceed to checkout"]
        XCTAssertFalse(button.exists)
    }
    
    func testStoreTabScreen() throws {
        let app = XCUIApplication()
        app.launch()
        
        let text = app.staticTexts["Categories"]
        XCTAssertTrue(text.exists)
        
        let list = app.collectionViews["categoriesList"]
        XCTAssertTrue(list.exists)
        XCTAssertEqual(list.cells.count, 4)
        
        XCTAssertTrue(list.cells.element(boundBy: 0).staticTexts["Hoodies"].exists)
        XCTAssertTrue(list.cells.element(boundBy: 1).staticTexts["Jackets"].exists)
        XCTAssertTrue(list.cells.element(boundBy: 2).staticTexts["Shoes"].exists)
        XCTAssertTrue(list.cells.element(boundBy: 3).staticTexts["T-shirts"].exists)
    }
    
    func testOrdersTabScreen() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars.element
        let ordersTab = tabBar.buttons["Orders"]
        ordersTab.tap()
        
        let text = app.staticTexts["Orders"]
        XCTAssertTrue(text.exists)
        
        let list = app.collectionViews["ordersList"]
        XCTAssertTrue(list.exists)
        XCTAssertEqual(list.cells.count, 3)
        
        XCTAssertTrue(list.cells.element(boundBy: 0).staticTexts["Order no. 1"].exists)
        XCTAssertTrue(list.cells.element(boundBy: 1).staticTexts["Order no. 2"].exists)
        XCTAssertTrue(list.cells.element(boundBy: 2).staticTexts["Order no. 3"].exists)
    }
    
    func testCategoryView() throws {
        let app = XCUIApplication()
        app.launch()
        
        let list = app.collectionViews["categoriesList"]
        let firstCategory = list.cells.element(boundBy: 0)
        
        firstCategory.tap()
        XCTAssertFalse(firstCategory.exists)
        XCTAssertFalse(list.exists)
        
        let text = app.staticTexts["Hoodies"]
        XCTAssertTrue(text.exists)
        
        let productslist = app.collectionViews["productsList"]
        XCTAssertTrue(productslist.exists)
        XCTAssertEqual(productslist.cells.count, 3)
        
        XCTAssertTrue(productslist.cells.element(boundBy: 0).staticTexts["Cozy Fleece Pullover"].exists)
        XCTAssertTrue(productslist.cells.element(boundBy: 1).staticTexts["Streetwear Zip-Up"].exists)
        XCTAssertTrue(productslist.cells.element(boundBy: 2).staticTexts["Tech-Knit Hoodie"].exists)
        
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists)
        
        let addButton = app.buttons["Add"]
        XCTAssertTrue(addButton.exists)
        
        backButton.tap()
        XCTAssertFalse(productslist.exists)
        XCTAssertFalse(backButton.exists)
        XCTAssertFalse(addButton.exists)
        XCTAssertTrue(firstCategory.exists)
        XCTAssertTrue(list.exists)
    }
}
