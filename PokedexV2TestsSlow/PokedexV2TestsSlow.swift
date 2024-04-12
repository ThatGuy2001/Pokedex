//
//  PokedexV2TestsSlow.swift
//  PokedexV2TestsSlow
//
//  Created by Diogo Filipe Abreu Rodrigues on 12/04/2024.
//

import XCTest
@testable import PokedexV2
final class PokedexV2TestsSlow: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testPokemonModelSimpeColor() throws {
        let promisse = expectation(description: "Testing pokemon with Simple Color")
        let bulbasaur = PokemonModel(name: "bulbasaur")
        bulbasaur.updatePokemon {
            XCTAssertEqual(bulbasaur.getColor(), UIColor.grass)
            promisse.fulfill()
        }
        wait(for: [promisse], timeout: 5)
    }
    
    func testPokemonModelNormalColorFisrt() {
        let promisse = expectation(description: "Testing pokemon with normal color first")
        let pidgey = PokemonModel(name: "pidgey")
        pidgey.updatePokemon {
            XCTAssertEqual(pidgey.getColor(), UIColor.flying)
            promisse.fulfill()
        }
        wait(for: [promisse], timeout: 5)
    }
    
    func testPokemonFavoriteStatus() {
        let promisse = expectation(description: "Testig favorite")
        let bulbasaur = PokemonModel(name: "bulbasaur")
        bulbasaur.updatePokemon {
            XCTAssertFalse(bulbasaur.isFavorite())
            bulbasaur.changeFavoriteStatus()
            XCTAssertTrue(bulbasaur.isFavorite())
            bulbasaur.changeFavoriteStatus()
            XCTAssertFalse(bulbasaur.isFavorite())
            promisse.fulfill()
        }
        wait(for: [promisse], timeout: 5)
    }
    
    func testPokemonUpdateStatus() {
        let promisse = expectation(description: "Testig status")
        let bulbasaur = PokemonModel(name: "bulbasaur")
        XCTAssertEqual(bulbasaur.updateStatus, .baseInfo)
        bulbasaur.updatePokemon {
            XCTAssertEqual(bulbasaur.updateStatus, .updateCalled)
            promisse.fulfill()
        }
        XCTAssertEqual(bulbasaur.updateStatus, .updateCalled)
        wait(for: [promisse], timeout: 5)
    }
    
    func testPokemonHp()  { // isolar testes
        let promisse = expectation(description: "Testing stats")
        let bulbasaur = PokemonModel(name: "bulbasaur")
        bulbasaur.updatePokemon {
            XCTAssertEqual(bulbasaur.getHp(), 45/216 )
            promisse.fulfill()
        }
        wait(for: [promisse], timeout: 5)
    }
    
    func testPokemonAtk()  { // isolar testes
        let promisse = expectation(description: "Testing stats")
        let bulbasaur = PokemonModel(name: "bulbasaur")
        bulbasaur.updatePokemon {
            XCTAssertEqual(bulbasaur.getAtk(), 49/110 )
            promisse.fulfill()
        }
        wait(for: [promisse], timeout: 5)
    }
    
    func testPokemonDef()  { // isolar testes
        let promisse = expectation(description: "Testing stats")
        let bulbasaur = PokemonModel(name: "bulbasaur")
        bulbasaur.updatePokemon {
            XCTAssertEqual(bulbasaur.getDef(), 49/230 )
            promisse.fulfill()
        }
        wait(for: [promisse], timeout: 5)
    }
    
    func testPokemonSpAtk()  { // isolar testes
        let promisse = expectation(description: "Testing stats")
        let bulbasaur = PokemonModel(name: "bulbasaur")
        bulbasaur.updatePokemon {
            XCTAssertEqual(bulbasaur.getSpAtk(), 65/194 )
            promisse.fulfill()
        }
        wait(for: [promisse], timeout: 5)
    }
    
    
    func testPokemonSpDef()  { // isolar testes
        let promisse = expectation(description: "Testing stats")
        let bulbasaur = PokemonModel(name: "bulbasaur")
        bulbasaur.updatePokemon {
            XCTAssertEqual(bulbasaur.getSpDef(), 65/230 )
            promisse.fulfill()
        }
        wait(for: [promisse], timeout: 5)
    }
    
    func testPokemonSpeed()  { // isolar testes
        let promisse = expectation(description: "Testing stats")
        let bulbasaur = PokemonModel(name: "bulbasaur")
        bulbasaur.updatePokemon {
            XCTAssertEqual(bulbasaur.getSpeed(), 45/180 )
            promisse.fulfill()
        }
        wait(for: [promisse], timeout: 5)
    }
    
    func testPokemonHeight() {
        let promisse = expectation(description: "Testing mesures")
        let bulbasaur = PokemonModel(name: "bulbasaur")
        bulbasaur.updatePokemon {
            XCTAssertEqual(bulbasaur.getHeight(), String(format: "Height: %dft", 7))
            promisse.fulfill()
        }
        wait(for: [promisse], timeout: 5)
    }
    
    func testPokemonWeight() {
        let promisse = expectation(description: "Testing mesures")
        let bulbasaur = PokemonModel(name: "bulbasaur")
        bulbasaur.updatePokemon {
            XCTAssertEqual(bulbasaur.getWeight(), String(format: "Weight: %dlb", 69))
            promisse.fulfill()
        }
        wait(for: [promisse], timeout: 5)
    }
    
    func testPokemonSpeciesInfoStatus() {
        let promisse = expectation(description: "Testing mesures")
        let bulbasaur = PokemonModel(name: "bulbasaur")
        XCTAssertEqual(bulbasaur.speciesStatus, .notCaled)
        bulbasaur.getSpeciesInfo {
            XCTAssertEqual(bulbasaur.speciesStatus, .concluded)
            promisse.fulfill()
        }
        XCTAssertEqual(bulbasaur.speciesStatus, .called)
        wait(for: [promisse], timeout: 5)
    }
    
    
}
