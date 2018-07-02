//
//  PokeCell.swift
//  Pokedex
//
//  Created by Gavin Craft on 6/19/18.
//  Copyright © 2018 Gavin Craft. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail:UIImageView!
    @IBOutlet weak var label:UILabel!
    
    var pokemon:Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
            layer.cornerRadius=5.0
    }
    
    func configurecell(pokemon:Pokemon){
        self.pokemon=pokemon
        label.text=self.pokemon.GETname().capitalized
        thumbnail.image=UIImage(named:"\(self.pokemon.GETid())")
    }
}
