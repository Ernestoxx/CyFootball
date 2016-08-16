//
//  TeamPointsViewController.swift
//  CyFootball
//
//  Created by Andreas Panayi on 1/19/16.
//  Copyright © 2016 CyFootball. All rights reserved.
//

import UIKit
import Parse

class TeamPointsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var teamPointsArray: [PFObject] = []
    var refreshControl: UIRefreshControl!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTeamsPointsFromParse()
        
        //set the background image of the tableView
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "stad")
        self.tableView.backgroundView = imageView
        
        //pull down refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(TeamPointsViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl) // not required when using UITableViewController
        
    }
    
    //pull down refresh
    func refresh(sender:AnyObject) {
        getTeamsPointsFromParse()
        self.refreshControl.endRefreshing()
    }
    override func viewWillAppear(animated: Bool) {
        getTeamsPointsFromParse()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTeamsPointsFromParse() {
        
        //writing a query, getting the cup data from the table TeamPoints
        let query = PFQuery(className: "TeamPoints")
        query.orderByAscending("Position")
        query.findObjectsInBackgroundWithBlock { (teamsArray, error) -> Void in
            if error == nil {
                self.teamPointsArray = teamsArray! as [PFObject]
                self.tableView.reloadData()
            } else {
                print(error)
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //create the custom cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamPointsCC", forIndexPath: indexPath) as! TeamPointsCC
        
        let row = indexPath.row
        
        let teamGameObject = self.teamPointsArray[row] as PFObject
        
        //saving the Name of the type.. First get the array and then make it string
        let teamName = teamGameObject.objectForKey("TeamName") as! String
        let gamesPlayed = teamGameObject.objectForKey("GamesPlayed") as! String
        let win = teamGameObject.objectForKey("Win") as! String
        let draw = teamGameObject.objectForKey("Draw") as! String
        let loss = teamGameObject.objectForKey("Loss") as! String
        let totalPoints = teamGameObject.objectForKey("TotalPoints") as! String
        let position = teamGameObject.objectForKey("Position") as! Int

        //setting the data
        cell.teamName.text = teamName
        cell.gamesPlayed.text = gamesPlayed
        cell.win.text = win
        cell.draw.text = draw
        cell.loss.text = loss
        cell.totalPoints.text = totalPoints
        cell.rankPosition.text = String(position)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamPointsArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}
