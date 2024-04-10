//
//  PokemonInfoView.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 02/04/2024.
//

import UIKit

class PokemonInfoView: UIViewController {

    var pokemon : PokemonModel?
    
    @IBOutlet weak var backgorundSprite: UIImageView!
    
    @IBOutlet weak var sprite: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var type1: UIImageView!
    @IBOutlet weak var type2: UIImageView!
    
    @IBOutlet weak var generation: UILabel!
    @IBOutlet weak var habitat: UILabel!
    @IBOutlet weak var captureRate: UILabel!
    @IBOutlet weak var growthRate: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var abilitiesView: UIStackView!
    
    //layout Constraits
    
    @IBOutlet weak var speciesInfoWidth: NSLayoutConstraint!
    @IBOutlet weak var speciesInfoHeight: NSLayoutConstraint!
    @IBOutlet weak var abilitiesWidth: NSLayoutConstraint!
    @IBOutlet weak var abilitesHeight: NSLayoutConstraint!
    @IBOutlet weak var baseInfoHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        navigationController?.navigationBar.tintColor = .white
        
        guard let pokemon = pokemon else { return  }
        prepareView(for:pokemon)
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer)  {
        if gesture.direction == .right {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            super.willTransition(to: newCollection, with: coordinator)
                choseLayout()
    }
    
    func changeLayout(_ w1: CGFloat, _ h1: CGFloat, _ w2: CGFloat, _ h2: CGFloat, _ w3: CGFloat ) {
        speciesInfoWidth = speciesInfoWidth.setMultiplier(multiplier: w1)
        speciesInfoHeight = speciesInfoHeight.setMultiplier(multiplier: h1)
        abilitiesWidth = abilitiesWidth.setMultiplier(multiplier: w2)
        abilitesHeight = abilitesHeight.setMultiplier(multiplier: h2)
        baseInfoHeight = baseInfoHeight.setMultiplier(multiplier: w3)
        view.layoutIfNeeded()
    }
    
    func prepareView(for pokemon: PokemonModel) {
        name.text = pokemon.name.capitalized
        height.text = pokemon.getHeight()
        weight.text = pokemon.getWeight()
        sprite.image = pokemon.sprites.male
        
        if let type1 = pokemon.type1 {
            self.type1.image = UIImage(named: type1)
        }
        if let type2 = pokemon.type2 {
            self.type2.isHidden = false
            self.type2.image = UIImage(named: type2)
        } else {
            type2.isHidden = true
        }
        
        guard let speciesInfo = pokemon.species else { return }
        
        generation.text = speciesInfo.generation.name.capitalized + " Pokemon"
        habitat.text = "Habitat : " + (speciesInfo.habitat?.name.capitalized ?? "Rare")
        captureRate.text = String(format: "Capture rate : %d", speciesInfo.capture_rate )
        growthRate.text = "Growth rate : " + speciesInfo.growth_rate.name
        desc.text = speciesInfo.flavor_text_entries[0].flavor_text.replacingOccurrences(of: "\n", with: " ")
        
        for abl in pokemon.abilities {
            let ability = UILabel()
            ability.text = abl.capitalized
            abilitiesView.addArrangedSubview(ability)
        }
        
        backgorundSprite.image = UIImage(named:speciesInfo.habitat?.name ?? "rare")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        choseLayout()
    }
    
    func choseLayout(){
        if UIDevice.current.orientation.isLandscape {
            changeLayout(0.7, 0.6, 0.3, 0.6, 0.4)
        } else {
            changeLayout(1, 0.4, 1, 0.4, 0.2)
        }
    }
}
