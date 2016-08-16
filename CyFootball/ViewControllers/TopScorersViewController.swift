//
//  TopScorersViewController.swift
//  CyFootball
//
//  Created by Andreas Panayi on 2/10/16.
//  Copyright © 2016 CyFootball. All rights reserved.
//

import UIKit
import Parse

class TopScorersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var topScorersArray: [PFObject] = []
    var refreshControl: UIRefreshControl!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTopScorersFromParse()
        
        //set the background image of the tableView
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "stad")
        self.tableView.backgroundView = imageView
        
        //pull down refresh

        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(TopScorersViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl) // not required when using UITableViewController
        
    }
    //pull down refresh
    func refresh(sender:AnyObject) {
        getTopScorersFromParse()
        self.refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        getTopScorersFromParse()
        
    }
    func getTopScorersFromParse() {
        
        //writing a query, getting the cup data from the table TeamScorers
        let query = PFQuery(className: "TopScorers")
        query.orderByAscending("Position")
        query.findObjectsInBackgroundWithBlock { (topScorersArray, error) -> Void in
            if error == nil {
                self.topScorersArray = topScorersArray! as [PFObject]
                self.tableView.reloadData()
            } else {
                print(error)
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //create the custom cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TopScorersCC", forIndexPath: indexPath) as! TopScorersCC
        
        let row = indexPath.row
        
        let teamGameObject = self.topScorersArray[row] as PFObject
        
        //saving the Name of the type.. First get the array and then make it string
        let playerName = teamGameObject.objectForKey("PlayerName") as! String
        let totalGoals = teamGameObject.objectForKey("Goals") as! String
        let penaltyGoals = teamGameObject.objectForKey("Penalty") as! String
        let position = teamGameObject.objectForKey("Position") as! Int
        
        //setting the data
        cell.playerName.text = playerName
        cell.totalGoals.text = totalGoals
        cell.penaltyGoals.text = penaltyGoals
        cell.rankPosition.text = String(position)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topScorersArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
