//
//  LoadingCell.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 17/04/2024.
//

import UIKit

class LoadingCell: UITableViewCell {

    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
