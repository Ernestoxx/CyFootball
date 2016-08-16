//
//  TeamPointsCC.swift
//  CyFootball
//
//  Created by Andreas Panayi on 1/19/16.
//  Copyright © 2016 CyFootball. All rights reserved.
//

import UIKit

class TeamPointsCC: UITableViewCell {

    @IBOutlet weak var totalPoints: UILabel!
    @IBOutlet weak var draw: UILabel!
    @IBOutlet weak var loss: UILabel!
    @IBOutlet weak var win: UILabel!
    @IBOutlet weak var gamesPlayed: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var rankPosition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
