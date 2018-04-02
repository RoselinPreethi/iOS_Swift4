//
//  TrackTableCell.swift
//  iTunesSongs
//
//  Created by Malini on 02/04/18.
//  Copyright © 2018 Roselin. All rights reserved.
//

import UIKit

class TrackTableCell: UITableViewCell {

    @IBOutlet weak var song2lbl: UILabel!
    @IBOutlet weak var song1lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
