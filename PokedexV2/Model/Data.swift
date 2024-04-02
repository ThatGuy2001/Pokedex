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
}

//MARK: - PokemonData

struct PokemonData : Codable {
    let id : Int
    let name : String
    let types : [Types]
    let abilities : [Ability]
    // stats
    let stats : [Stat] // hp, atc, def, sAtc, sDef, speed
    let weight : Int
    let height : Int
}

struct Ability : Codable {
    let ability : _ability
}

struct _ability : Codable {
    let name : String
}

struct Types : Codable {
    let slot : Int
    let type : _Type
}

struct _Type : Codable {
    let name : String
}

struct Stat : Codable {
    let base_stat : Int
}

//MARK: - TypeData

struct TypeData : Codable {
    let id : Int
    let name : String
    let pokemon : [TPokemon]
}

struct TPokemon : Codable {
    let pokemon : Pokemon
}

//MARK: - SpeciesData

struct SpeciesData : Codable {
    let capture_rate : Int
    let generation : Generation
    let growth_rate : GrowthRate
    let habitat : Habitat
    let flavor_text_entries : [FlavorTextEntrie]
}

struct Generation : Codable {
    let name : String
}

struct GrowthRate : Codable {
    let name : String
}

struct Habitat : Codable {
    let name : String
}

struct FlavorTextEntrie : Codable  {
    let flavor_text : String
}
