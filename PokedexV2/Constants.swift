//
//  Constants.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 12/03/2024.
//

import Foundation

struct K {
    struct url {
        static let firstPage = "https://pokeapi.co/api/v2/pokemon?limit=10&offset=0"
        static let pokemon = "https://pokeapi.co/api/v2/pokemon/"
        static let type = "https://pokeapi.co/api/v2/type/"
        static let defaultSprite = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
        static let shinySprite = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/"
        static let species = "https://pokeapi.co/api/v2/pokemon-species/"
    }
    struct identifiers {
        static let PokemonCell = "PokemonCell"
        static let LoadingCell = "LoadingCell"
        static let PokemonInfoSegue = "ToPokemonInfo"
    }
    static let types = ["normal", "fighting", "flying", "poison", "ground", "rock", "bug", "ghost", "physical", "fire", "water", "grass", "electric", "psychic", "ice", "dragon","dark", "fairy"]
    static let all = "all"
    static let onePokemon = "onePokemon"
    static let pagingNumber = 20
}
