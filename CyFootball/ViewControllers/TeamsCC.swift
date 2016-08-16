//
//  TeamsCC.swift
//  CyFootball
//
//  Created by Andreas Panayi on 12/27/15.
//  Copyright © 2015 CyFootball. All rights reserved.
//

import UIKit

class TeamsCC: UITableViewCell {
    
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
