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
            name.text = pokemon.name
            id.text = String(format: "#%03d", pokemon.id ?? 0)
            if let type1 = pokemon.type1 {
                self.type1.image = UIImage(named: type1)
            }
            if let type2 = pokemon.type2 {
                self.type2.image = UIImage(named: type2)
            } else {
                type2.isHidden = true
            }
            sprite.image = pokemon.front
        }
    }
}
