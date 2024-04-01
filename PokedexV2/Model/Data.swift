//
//  Data.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 12/03/2024.
//

import Foundation

//MARK: - PokemonListData

struct PokemonListData : Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results : [Pokemon] 
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
    let sprites : SpritesData
    // stats
    let stats : [Stat] // hp, atc, def, sAtc, sDef, speed
    let weight : Int
    let height : Int
}

struct Types : Codable {
    let slot : Int
    let type : _Type
}

struct _Type : Codable {
    let name : String
    let url : String
}

struct SpritesData : Codable {
    let front_default : String?
    let front_shiny : String?
}

struct Stat : Codable {
    let base_stat : Int
}

//MARK: - Type

struct TypeData : Codable {
    let id : Int
    let name : String
    let pokemon : [TPokemon]
}

struct TPokemon : Codable {
    let pokemon : Pokemon
}
