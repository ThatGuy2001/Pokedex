//
//  PokedexV2UITests.swift
//  PokedexV2UITests
//
//  Created by Diogo Filipe Abreu Rodrigues on 11/03/2024.
//

import XCTest

final class PokedexV2UITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testSelectPokemon() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCUIApplication()/*@START_MENU_TOKEN@*/.staticTexts["More info"]/*[[".buttons[\"More info\"].staticTexts[\"More info\"]",".staticTexts[\"More info\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }
    
    func testSwipeRight() {
        let app = XCUIApplication()
        let element = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2)
        element.swipeLeft()
        element.swipeLeft()
        app.staticTexts["Capture rate : 45"].swipeRight()
    }
    
    func testSearch() {
        
        let app = XCUIApplication()
        app.navigationBars["PokeApi"].buttons["Search"].tap()
        
        let fKey = app/*@START_MENU_TOKEN@*/.keyboards.keys["f"]/*[[".keyboards.keys[\"f\"]",".keys[\"f\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        fKey.tap()
        fKey.tap()
        
        let iKey = app/*@START_MENU_TOKEN@*/.keyboards.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        iKey.tap()
        iKey.tap()
        
        let app2 = app
        app2/*@START_MENU_TOKEN@*/.keyboards.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        
        let eKey = app2/*@START_MENU_TOKEN@*/.keyboards.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        eKey.tap()
        eKey.tap()
        app.alerts["Search"].scrollViews.otherElements.buttons["Search"].tap()
        app.tables.children(matching: .cell).element(boundBy: 4).children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        app2/*@START_MENU_TOKEN@*/.staticTexts["More info"]/*[[".buttons[\"More info\"].staticTexts[\"More info\"]",".staticTexts[\"More info\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
    }
    
    func testLayoutChange(){
        XCUIDevice.shared.orientation = .landscapeLeft
        let app = XCUIApplication()
        sleep(2)
        app/*@START_MENU_TOKEN@*/.staticTexts["More info"]/*[[".buttons[\"More info\"].staticTexts[\"More info\"]",".staticTexts[\"More info\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2)
        app.navigationBars["PokedexV2.PokemonInfoView"].buttons["PokeApi"].tap()
                
    }
    
    
    func testShiny() {
        
        let app = XCUIApplication()
        let element = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1)
        element.tap()
        element.tap()
       
    }
    
    func testSwipeTableView() {
        
        let app = XCUIApplication()
        let element = app.tables.element
        element.swipeUp(velocity: .fast)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
        
}
