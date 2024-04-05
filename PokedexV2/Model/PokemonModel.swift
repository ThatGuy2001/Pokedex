//
//  PokemonModel.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 12/03/2024.
//

import UIKit

protocol PokemonModelDelegate {
    func didEndUpdateSpecies()
    func didEndUpdate()
    func didNotUpdate()
}

struct Sprites {
    var male : UIImage?
    var maleShiny : UIImage?
}

enum UpdateStatus {
    case baseInfo
    case updateCalled
    case updateEnded
}

enum SpeciesUpdateStatus {
    case notCaled
    case called
    case concluded
}
class PokemonModel {
    
    var delegade : PokemonModelDelegate?
    var requestManger : RequestManager
    
    var updateStatus : UpdateStatus
    var speciesStatus : SpeciesUpdateStatus
    
    var name : String
    var id : Int
    var stats : [Int]
    var sprites : Sprites
    var weight : Int
    var height : Int
    var abilities : [String]
    
    
    var type1 : String?
    var type2 : String?
    
    var species : SpeciesData?
    
    init(name: String) {
        updateStatus = .baseInfo
        speciesStatus = .notCaled
        self.name = name
        id = 0
        sprites = Sprites()
        stats = []
        weight = 0
        height = 0
        abilities = []
        requestManger = RequestManager()
        requestManger.delegate = self
    }
    
    func updatePokemon() {
        if updateStatus == .baseInfo {
            updateStatus = .updateCalled
            requestManger.fetchData(for: .pokemon(name))
        }
    }
    
    func updateSprites() {
        let sId = String(id) + ".png"
        requestSprite(url: K.url.defaultSprite + sId, type: .male)
        requestSprite(url: K.url.shinySprite + sId, type: .maleShiny)
    }
    
    func requestSprite(url : String, type : SpriteType) {
        requestManger.fetchData(for: .sprite(url, type))
    }
    
    func getSpeciesInfo(){
        if speciesStatus == .notCaled {
            requestManger.fetchData(for: .species(name))
            speciesStatus =  .called
        }
    }
    
    func getHp() -> Float { // max hp 216
        return Float(stats[0]) / 216
    }
    func getAtk() -> Float { // max atc 110
        return Float(stats[1]) / 110
    }
    func getDef() -> Float { // max def 230
        return Float(stats[2]) / 230
    }
    func getSpAtk() -> Float { // max spAtc 194
        return Float(stats[3]) / 194
    }
    func getSpDef() -> Float { // max spDef 230
        return Float(stats[4]) / 230
    }
    func getSpeed() -> Float { // max speed 180
        return Float(stats[5]) / 180
    }
    
    func getHeight() -> String  {
        String(format: "Height: %dft", height)
    }
    
    func getWeight() -> String {
        String(format: "Weight: %dlb", weight)
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
            height = pokemon.height
            weight = pokemon.weight
            stats = pokemon.stats.map { $0.base_stat }
            abilities = pokemon.abilities.map{$0.ability.name}
            
            type1 = pokemon.types[0].type.name
            if pokemon.types.count > 1 {
                type2 = pokemon.types[1].type.name
            }
            
            updateSprites()
        } else if let sprite = data as? SpriteModel {
            switch sprite.type {
            case .male:
                sprites.male = sprite.sprite
                updateStatus = .updateEnded
                delegade?.didEndUpdate()
            case .maleShiny:
                sprites.maleShiny = sprite.sprite
            }
        } else if let species = data as? SpeciesData {
            self.species = species
            speciesStatus = .concluded
            delegade?.didEndUpdateSpecies()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


