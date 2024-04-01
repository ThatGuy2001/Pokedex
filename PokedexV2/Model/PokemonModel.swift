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
    
    enum UpdateStatus {
        case baseInfo
        case updateCalled
        case updateEnded
    }
    
    
    var delegade : PokemonModelDelegate?
    var requestManger : RequestManager
    var updateStatus : UpdateStatus
    
    var name : String
    
    var id : Int
    var type1 : String?
    var type2 : String?
    
    var sprites : [UIImage] = []
    var spriteIndex = 0
    
    var stats : [Int]
    var weight : Int?
    var height : Int?
    
    init(name: String) {
        self.name = name
        id = 0
        requestManger = RequestManager()
        requestManger.delegate = self
        updateStatus = .baseInfo
    }
    
    func updatePokemon() {
        if updateStatus == .baseInfo {
            updateStatus = .updateCalled
            requestManger.fetchData(for: RequestType.pokemon(name))
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
    
    func requestSprite(url : String, type : SpriteType) {
        requestManger.fetchData(for: RequestType.sprite(url, type))
    }
    
    func getStats() {
        // max hp 216
        // max atc 110
        // max def 230
        // max spAtc 194
        // max spDef 230
        // max speed 180
    }
    
    func getHeight() -> String  {
        String(format: "Height: %dft", height ?? 0)
    }
    
    func getWeight() -> String {
        String(format: "Weight: %dlb", weight ?? 0)
    }
    
    func getColor() -> UIColor? {
        guard let type1 = self.type1 else { return UIColor(named: "normal") }
        guard let type2 = self.type2 else {return UIColor(named: type1)}
        
        if type1 == "normal" {
            return UIColor(named: type2)
        }
         return UIColor(named: type1)
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
                updateStatus = .updateEnded
                delegade?.didEndUpdate()
            default:
                sprites.append(sprite.sprite)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


