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
        static let defaultSprite = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/" //{id}.png
        static let shinySprite = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/" //{id}.png
    }
    struct identifiers {
        static let PokemonCell = "PokemonCell"
    }
    static let types = ["normal", "fighting", "flying", "poison", "ground", "rock", "bug", "ghost", "physical", "fire", "water", "grass", "electric", "psychic", "ice", "dragon","dark", "fairy"]
}
