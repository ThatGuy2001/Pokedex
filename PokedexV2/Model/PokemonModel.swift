//
//  PokemonModel.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 12/03/2024.
//

import UIKit

protocol PokemonModelDelegate {
    func didEndUpdate()
    func didNotUpdate()
}

class PokemonModel {
    
    var delegade : PokemonModelDelegate?
    
    var requestManger : RequestManager
    
    var name : String
    var url : String
    var updateCalled : Bool
    var updateEnded : Bool
    var shiny : Bool
    
    var id : Int?
    var type1 : String?
    var type2 : String?
    
    var front : UIImage?
    var frontShiny : UIImage?
    
    
    init(name: String, url: String) {
        requestManger = RequestManager()
        self.name = name
        self.url = url
        updateCalled = false
        updateEnded = false
        shiny = false
        
        requestManger.delegate = self
    }
    
    func updatePokemon() {
        if !updateCalled {
            updateCalled = true
            let request : RequestType = .pokemon(url)
            requestManger.fetchData(for: request)
        }
    }
    
    func updateSprites(sprites: Sprites) {
        if let front = sprites.front_default {
            requestSprite(url: front, type: .front)
        }
        
        if let frontShiny = sprites.front_shiny {
            requestSprite(url: frontShiny, type: .frontShiny)
        }
    }
    
    func requestSprite(url : String, type : SpriteType){
        let request : RequestType = .sprite(url, type)
        requestManger.fetchData(for: request)
    }
}

//MARK: - RequestManagerDelegate

extension PokemonModel : RequestManagerDelegate {
    func didUpdate(data: Any) {
        if let pokemon = data as? PokemonData {
            id = pokemon.id
            type1 = pokemon.types[0].type.name
            if pokemon.types.count > 1 {
                type2 = pokemon.types[1].type.name
            }
            updateSprites(sprites: pokemon.sprites)
        } else if let sprite = data as? SpriteModel {
            switch sprite.type {
            case .front:
                front = sprite.sprite
                updateEnded = true
                delegade?.didEndUpdate()
            case .frontShiny:
                frontShiny = sprite.sprite
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


