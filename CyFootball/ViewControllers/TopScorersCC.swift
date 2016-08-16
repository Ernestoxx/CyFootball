//
//  TopScorersCC.swift
//  CyFootball
//
//  Created by Andreas Panayi on 2/10/16.
//  Copyright © 2016 CyFootball. All rights reserved.
//

import UIKit

class TopScorersCC: UITableViewCell {

    @IBOutlet weak var rankPosition: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var totalGoals: UILabel!
    @IBOutlet weak var penaltyGoals: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
