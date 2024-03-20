//
//  PokemonViewController.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 15/03/2024.
//

import UIKit

class PokemonViewController : UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var type1: UIImageView!
    @IBOutlet weak var type2: UIImageView!
    
    @IBOutlet weak var sprite: UIImageView!
    
    
    var pokemon : PokemonModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preparePokemonView()
    }
    
    func preparePokemonView(){
        if let pokemon {
            pokemon.spriteIndex = 0
            name.text = pokemon.name.capitalized
            id.text = String(format: "#%03d", pokemon.id)
            if let type1 = pokemon.type1 {
                self.type1.image = UIImage(named: type1)
            }
            if let type2 = pokemon.type2 {
                self.type2.image = UIImage(named: type2)
            } else {
                type2.isHidden = true
            }
            sprite.image = pokemon.sprites[0]
        }
    }
    
    
    @IBAction func tapPokemon(_ sender: UITapGestureRecognizer) {
        if let pokemon {
            if pokemon.spriteIndex >= pokemon.sprites.count-1 {
                pokemon.spriteIndex = 0
            } else {
                pokemon.spriteIndex += 1
            }
            print(pokemon.spriteIndex)
            sprite.image = pokemon.sprites[pokemon.spriteIndex]
        }
    }
    
}
