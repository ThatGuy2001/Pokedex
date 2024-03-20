//
//  MoveModel.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 20/03/2024.
//

import UIKit

class MoveModel {
    var name : String
    var url : String
    var levelLerned : Int
    
    var pp : Int?
    var power : Int?
    var accuracy : Int?
    var type: String?
    
    init(name: String, url: String, levelLerned : Int) {
        self.name = name
        self.url = url
        self.levelLerned = levelLerned
    }
}
