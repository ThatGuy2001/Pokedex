//
//  Constants.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 12/03/2024.
//

import Foundation

struct K {
    struct Url {
        static let firstPage = "https://pokeapi.co/api/v2/pokemon?limit=10&offset=0"
        static let pokemonUrl = "https://pokeapi.co/api/v2/pokemon/"
        static let typeUrl = "https://pokeapi.co/api/v2/type/"
    }
    struct Identifiers {
        static let PokemonCell = "PokemonCell"
    }
    static let types = ["normal", "fighting", "flying", "poison", "ground", "rock", "bug", "ghost", "physical", "fire", "water", "grass", "electric", "psychic", "ice", "dragon","dark", "fairy"]
}
