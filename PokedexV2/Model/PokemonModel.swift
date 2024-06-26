//
//  PokemonModel.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 12/03/2024.
//

import UIKit
import Alamofire

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
    
    var updateStatus : UpdateStatus
    var speciesStatus : SpeciesUpdateStatus
    var favorite : Bool
    
    var name : String
    var id : Int
    var stats : [Int]
    var sprites : Sprites
    var weight : Int
    var height : Int
    var abilities : [String]
    
    var type1 : String?
    var type2 : String?
    
    var speciesInfo : SpeciesData?
    
    init(name: String) {
        favorite = false
        updateStatus = .baseInfo
        speciesStatus = .notCaled
        self.name = name
        id = 0
        sprites = Sprites()
        stats = [0,0,0,0,0,0]
        weight = 0
        height = 0
        abilities = []
    }
    
    func changeFavoriteStatus() {
        favorite = !favorite
        
        var parameters = [ "name" : name, "id" : String(id), "operation" : " "]
        
        if isFavorite(){
            parameters["operation"] = "add-favorite"
        } else {
            parameters["operation"] = "remove-favorite"
        }
        
        AF.request("https://webhook.site/e1b0731a-59c9-455a-a27b-20365f2da8f8",method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).response { response in
            print(response.description)
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
    
    func isFavorite() -> Bool {
        return favorite
    }
    
    func getColor() -> UIColor? {
        guard let type1 = self.type1 else { return UIColor(named: "normal") }
        guard let type2 = self.type2 else {return UIColor(named: type1)}
        
        if type1 == "normal" {
            return UIColor(named: type2)
        }
         return UIColor(named: type1)
    }
    
    func updatePokemon(completionHandler : @escaping () -> Void) {
        if updateStatus == .baseInfo {
            updateStatus = .updateCalled
            AF.request(K.url.pokemon + name ).responseDecodable(of: PokemonData.self) { response in
                guard let response = response.value else { return }
                self.baseInfoHandler(response, completionHandler: completionHandler )
            }
        }
    }
    
    func baseInfoHandler(_ pokemon : PokemonData, completionHandler : @escaping () -> Void) {
        id = pokemon.id
        height = pokemon.height
        weight = pokemon.weight
        stats = pokemon.stats.map { $0.base_stat }
        abilities = pokemon.abilities.map{$0.ability.name}
        
        type1 = pokemon.types[0].type.name
        if pokemon.types.count > 1 {
            type2 = pokemon.types[1].type.name
        }
        
        completionHandler()
    }
    
    func updateSprites(completionHandler : @escaping () -> Void) {
        let sId = String(id) + ".png"
        let shinyUrl = K.url.shinySprite + sId
        let defaultUrl = K.url.defaultSprite + sId
        
        AF.request(shinyUrl).responseData { response in
            guard let data = response.data else { return }
            self.spriteHandler(UIImage(data: data), shinyUrl, completionHandler: completionHandler )
        }
        
        AF.request(defaultUrl).responseData { response in
            guard let data = response.data else { return }
            self.spriteHandler(UIImage(data: data), defaultUrl, completionHandler: completionHandler )
        }
    }
    
    func spriteHandler(_ sprite : UIImage?, _ url : String , completionHandler : @escaping () -> Void ) {
        if url.contains("shiny"){
            sprites.maleShiny = sprite ?? UIImage(named: "pokeball")
        } else {
            sprites.male = sprite ?? UIImage(named: "pokeball")
            updateStatus = .updateEnded
            completionHandler()
        }
    }
    
    func getSpeciesInfo( completionHandler  : @escaping () -> Void){
        if speciesStatus == .notCaled {
            speciesStatus =  .called
            AF.request(K.url.species + name).responseDecodable(of: SpeciesData.self) { response in
                guard let response = response.value else { return }
                self.speciesInfoHandler(response)
                completionHandler()
            }
        }
    }
    
    func speciesInfoHandler(_ species : SpeciesData){
        self.speciesInfo = species
        speciesStatus = .concluded
    }
}
