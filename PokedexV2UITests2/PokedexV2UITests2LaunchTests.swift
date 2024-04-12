//
//  PokedexV2UITests2LaunchTests.swift
//  PokedexV2UITests2
//
//  Created by Diogo Filipe Abreu Rodrigues on 12/04/2024.
//

import XCTest

final class PokedexV2UITests2LaunchTests: XCTestCase {
    var app: XCUIApplication = XCUIApplication()
    
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testSelectPokemon() {
        
    }
}
