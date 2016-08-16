//
//  MatchInfoViewController.swift
//  CyFootball
//
//  Created by Andreas Panayi on 1/20/16.
//  Copyright © 2016 CyFootball. All rights reserved.
//

import UIKit
import Parse



class MatchInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var score: UILabel!
    
    //the data that are passed from the segue before
    var scores: String?
    var homeTeamLogos: UIImage?
    var awayTeamLogos: UIImage?
    var heightCell = false
    var teamGameDetailsArray: [PFObject] = []
    var matchID: String?
    var refreshControl: UIRefreshControl!



    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the title
        self.title = "Ανάλυση Αγώνα"
        
        getTeamGameDetailsLeaueDataFromParse()
        
        //set the data from the segue
        homeTeamLogo.image = homeTeamLogos
        awayTeamLogo.image = awayTeamLogos
        score.text = scores

        //pull down refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(MatchInfoViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl) // not required when using UITableViewController
        
    }
    //pull down refresh
    func refresh(sender:AnyObject) {
        getTeamGameDetailsLeaueDataFromParse()
        self.refreshControl.endRefreshing()
    }
    override func viewWillAppear(animated: Bool) {
        getTeamGameDetailsLeaueDataFromParse()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getTeamGameDetailsLeaueDataFromParse() {
        
        //writing a query, getting the cup data from the table MatchesHistory
        let query = PFQuery(className: "MatchesHistory")
        query.whereKey("MatchID", equalTo: matchID!)
        query.findObjectsInBackgroundWithBlock { (teamGamesArray, error) -> Void in
            if error == nil {
                self.teamGameDetailsArray = teamGamesArray! as [PFObject]
                self.tableView.reloadData()
            } else {
                print(error)
            }
        }
     
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let teamGameObject = self.teamGameDetailsArray[row] as PFObject
                
        if teamGameObject.objectForKey("HomeTeamMatchHistory") != nil {

            //create the custom left cell
            let cell = tableView.dequeueReusableCellWithIdentifier("HomeTeamDetailCC", forIndexPath: indexPath) as! HomeTeamDetailCC
        
            let homeTeamInformation = teamGameObject.objectForKey("HomeTeamMatchHistory") as? String
            let homeTeamPicture = teamGameObject.objectForKey("HomeTeamPicture") as! PFFile
            let homeTeamMinute = teamGameObject.objectForKey("HomeTeamMinute") as! String

            cell.homeTeamInformation.text = homeTeamInformation
            cell.homeTeamTime.text = homeTeamMinute
            
            
            homeTeamPicture.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                let image: UIImage! = UIImage(data: imageData!)!
                cell.homeTeamPicture.image = image
            })
            heightCell = false

            
            return cell
                
            
        } else if teamGameObject.objectForKey("AwayTeamMatchHistory") != nil {
            
            //create the custom right cell
            let cell = tableView.dequeueReusableCellWithIdentifier("AwayTeamDetailCC", forIndexPath: indexPath) as! AwayTeamDetailCC
            
            let awayTeamInformation = teamGameObject.objectForKey("AwayTeamMatchHistory") as? String
            let awayTeamPicture = teamGameObject.objectForKey("AwayTeamPicture") as! PFFile
            let awayTeamMinute = teamGameObject.objectForKey("AwayTeamMinute") as! String
            
            cell.awayTeamInformation.text = awayTeamInformation
            cell.awayTeamTime.text = awayTeamMinute
            
            
            awayTeamPicture.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                let image: UIImage! = UIImage(data: imageData!)!
                cell.awayTeamPicture.image = image
            })
            heightCell = false


            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("YouTubeCC", forIndexPath: indexPath) as! YouTubeCC
            
            let youtubeURL = teamGameObject.objectForKey("YouTubeURL") as? String
            
            //get the view width
            let viewWidth = String(self.view.frame.width - 7)
            
            let newYoutubeURL = youtubeURL?.stringByReplacingOccurrencesOfString("560", withString: viewWidth)
            
            cell.youtube.loadHTMLString(newYoutubeURL!, baseURL: nil)
            
            //use this so we can check wich cell is in heightForRowAtIndexPath
            heightCell = true
            
            return cell
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //change the height of youtube cell
        if heightCell {
            return 315
        } else {
            return 30
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamGameDetailsArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
