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
    
    @IBOutlet weak var hp: UIProgressView!
    @IBOutlet weak var attack: UIProgressView!
    @IBOutlet weak var defense: UIProgressView!
    @IBOutlet weak var spAttack: UIProgressView!
    @IBOutlet weak var spDef: UIProgressView!
    @IBOutlet weak var speed: UIProgressView!
    
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var spAttackLabel: UILabel!
    @IBOutlet weak var spDefLabel: UILabel!
    @IBOutlet weak var SpeedLabel: UILabel!
    
    
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    
    var pokemon : PokemonModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preparePokemonView()
    }
    
    func preparePokemonView() {
        
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
            
            
            prepareStats()
            
            
            height.text = pokemon.getHeight()
            weight.text = pokemon.getWeight()
            
        }
    }
    
    func prepareStats(){
        let statsBars = [hp,attack,defense,spAttack,spDef,speed]
        let statsLabels = [hpLabel,attackLabel,defenseLabel,spAttackLabel,spDefLabel,SpeedLabel]
        guard let stats = pokemon?.getStats() else { return }
        for i in 0..<6 {
            statsBars[i]?.progress = Float(stats[i]) / 300
            statsLabels[i]?.text = String(format: "%3d", stats[i])
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
