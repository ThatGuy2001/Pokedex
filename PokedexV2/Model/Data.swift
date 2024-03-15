//
//  Data.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 12/03/2024.
//

import Foundation

//MARK: - PokemonListData

struct PokemonListData : Codable {
    var count: Int = 0
    var next: String? = nil
    var previous: String? = nil
    var results : [Pokemon] = []
}

struct Pokemon : Codable {
    let name: String
    let url : String
}

//MARK: - PokemonData

struct PokemonData : Codable {
    let id : Int
    let name : String
    let types : [Types]
    let sprites : Sprites
}

struct Types : Codable {
    let slot : Int
    let type : _Type
}

struct _Type : Codable {
    let name : String
    let url : String
}

struct Sprites : Codable {
    let front_default : String?
    let front_shiny : String?
}
