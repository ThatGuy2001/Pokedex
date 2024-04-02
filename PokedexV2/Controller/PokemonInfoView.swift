//
//  PokemonInfoView.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 02/04/2024.
//

import UIKit

class PokemonInfoView: UIViewController {

    var pokemon : PokemonModel?
    
    //layout Constraits
    
    @IBOutlet weak var speciesInfoWidth: NSLayoutConstraint!
    @IBOutlet weak var speciesInfoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var abilitiesWidth: NSLayoutConstraint!
    @IBOutlet weak var abilitesHeight: NSLayoutConstraint!
    
    @IBOutlet weak var baseInfoHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let pokemon = pokemon else { return  }
        print(pokemon.name)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            super.willTransition(to: newCollection, with: coordinator)
                if UIDevice.current.orientation.isLandscape {
                    changeLayout(0.5, 0.6, 0.5, 0.6, 0.4)
                } else {
                    changeLayout(1, 0.4, 1, 0.4, 0.2)
                }
    }
    
    func changeLayout(_ w1: CGFloat, _ h1: CGFloat, _ w2: CGFloat, _ h2: CGFloat, _ w3: CGFloat ) {
        speciesInfoWidth = speciesInfoWidth.setMultiplier(multiplier: w1)
        speciesInfoHeight = speciesInfoHeight.setMultiplier(multiplier: h1)
        abilitiesWidth = abilitiesWidth.setMultiplier(multiplier: w2)
        abilitesHeight = abilitesHeight.setMultiplier(multiplier: h2)
        baseInfoHeight = baseInfoHeight.setMultiplier(multiplier: w3)
        view.layoutIfNeeded()
    }
}
