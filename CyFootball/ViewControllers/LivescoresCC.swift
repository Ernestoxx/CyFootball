//
//  LivescoresCC.swift
//  CyFootball
//
//  Created by Andreas Panayi on 2/27/16.
//  Copyright © 2016 CyFootball. All rights reserved.
//

import UIKit

class LivescoresCC: UITableViewCell {

    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var matchDate: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
