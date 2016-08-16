//
//  YouTubeCC.swift
//  CyFootball
//
//  Created by Andreas Panayi on 2/8/16.
//  Copyright © 2016 CyFootball. All rights reserved.
//

import UIKit

class YouTubeCC: UITableViewCell {

    @IBOutlet weak var youtube: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.frame = CGRectMake(0, 0, self.frame.size.width, 200)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
