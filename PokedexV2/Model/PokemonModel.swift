//
//  PokemonModel.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 12/03/2024.
//

import UIKit

protocol PokemonModelDelegate {
    func didEndUpdate()
    func didUpdateStats()
    func didNotUpdate()
}

class PokemonModel {
    
    var delegade : PokemonModelDelegate?
    
    var requestManger : RequestManager
    
    var name : String
    var url : String
    var updateCalled : Bool
    var updateEnded : Bool
    
    var id : Int
    var type1 : String?
    var type2 : String?
    
    var sprites : [UIImage] = []
    var spriteIndex = 0
    
    var stats : PokemonStatsData?
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
        id = 0
        updateCalled = false
        updateEnded = false
        
        requestManger = RequestManager()
        requestManger.delegate = self
    }
    
    func updatePokemon() {
        if !updateCalled {
            updateCalled = true
            requestManger.fetchData(for: RequestType.pokemon(url))
        }
    }
    
    func updateSprites(sprites: Sprites) {
        if let front = sprites.front_default {
            requestSprite(url: front, type: .male)
        }
        if let frontShiny = sprites.front_shiny {
            requestSprite(url: frontShiny, type: .maleShiny)
        }
    }
    
    func fetchPokemonStats() {
        requestManger.fetchData(for: RequestType.stats(url))
    }
    
    func requestSprite(url : String, type : SpriteType) {
        requestManger.fetchData(for: RequestType.sprite(url, type))
    }
    
    func getStats() -> [Int]? {
        guard let stats = self.stats?.stats else { return nil }
        return stats.map { $0.base_stat }
    }
    
    func getHeight() -> String  {
        String(format: "Height: %dft", stats?.height ?? 0)
    }
    
    func getWeight() -> String {
        String(format: "Weight: %dlb", stats?.weight ?? 0)
    }
    
    func getColor() -> UIColor? {
        guard let type = type1 else { return UIColor(named: "normal") }
        return UIColor(named: type)
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
            case .male:
                sprites.insert(sprite.sprite, at: 0)
                updateEnded = true
                delegade?.didEndUpdate()
            default:
                sprites.append(sprite.sprite)
            }
        } else if let stats = data as? PokemonStatsData {
            self.stats = stats
            delegade?.didUpdateStats()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


