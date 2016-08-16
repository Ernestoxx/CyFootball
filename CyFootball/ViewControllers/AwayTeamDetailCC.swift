//
//  AwayTeamDetailCC.swift
//  CyFootball
//
//  Created by Andreas Panayi on 1/21/16.
//  Copyright © 2016 CyFootball. All rights reserved.
//

import UIKit

class AwayTeamDetailCC: UITableViewCell {

    @IBOutlet weak var awayTeamTime: UILabel!
    @IBOutlet weak var awayTeamPicture: UIImageView!
    @IBOutlet weak var awayTeamInformation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
