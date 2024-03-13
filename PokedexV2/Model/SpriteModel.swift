//
//  SpriteModel.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 12/03/2024.
//

import UIKit

enum SpriteType {
    case front
    case frontShiny
}

class SpriteModel {
    var sprite : UIImage
    var type : SpriteType
    
    init(sprite: UIImage, type: SpriteType) {
        self.sprite = sprite
        self.type = type
    }
}
