//
//  PokemonCell.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 11/03/2024.
//

import UIKit

class PokemonCell: UITableViewCell {


    @IBOutlet weak var sprite: UIImageView!
    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
