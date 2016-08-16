//
//  TeamGamesCC.swift
//  CyFootball
//
//  Created by Andreas Panayi on 12/28/15.
//  Copyright © 2015 CyFootball. All rights reserved.
//

import UIKit

class TeamGamesCC: UITableViewCell {
    
    @IBOutlet weak var matchDate: UILabel!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var score: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
