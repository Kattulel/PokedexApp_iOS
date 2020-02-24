//
//  PokedexListCell.swift
//  PokeDex
//
//  Created by user160618 on 11/30/19.
//  Copyright © 2019 unifor2019.2. All rights reserved.
//

import UIKit


class PokedexListCell: UITableViewCell {
    

    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var btnFavorites: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    
    var Id = Int()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
