//
//  MoveCell.swift
//  Pokedex
//
//  Created by Gavin Craft on 7/1/18.
//  Copyright © 2018 Gavin Craft. All rights reserved.
//

import UIKit

class MoveCell: UITableViewCell {
    @IBOutlet weak var moveDamage: UILabel!
    @IBOutlet weak var moveName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius=5.0
    }
}
