//
//  TeamsViewController.swift
//  CyFootball
//
//  Created by Andreas Panayi on 12/27/15.
//  Copyright © 2015 CyFootball. All rights reserved.
//

import UIKit
import Parse

class TeamsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var teamsArray: [PFObject] = []
    var refreshControl: UIRefreshControl!

    
    enum teamError {
        
        case CantFindTeam
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTeamsDataFromParse()

        //set the background image of the tableView
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "stad")
        self.tableView.backgroundView = imageView
        
        //pull down refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(TeamsViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl) // not required when using UITableViewController
        
    }
    
    //pull down refresh
    func refresh(sender:AnyObject) {
        getTeamsDataFromParse()
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        getTeamsDataFromParse()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTeamsDataFromParse() {
        
        if Reachability.isConnectedToNetwork() {
        
        //writing a query, getting data from the table Teams
            let query = PFQuery(className: "Teams")
            query.findObjectsInBackgroundWithBlock { (teamsArray, error) -> Void in
                if error == nil {
                    self.teamsArray = teamsArray! as [PFObject]
                    self.tableView.reloadData()
                } else {
                    print(error)
                }
            }
        } else {
            
            //initializes the alert view
            let alert = UIAlertController(title: "Δεν βρέθηκε σύνδεση με το διαδύκτιο!", message: "Παρακαλώ ενεργοποιήστε τη σύνδεση σας στο διαδύκτιο και ξανά προσπαθείστε.", preferredStyle: UIAlertControllerStyle.Alert)
            
            //Show the "Ok" Button
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
            }
            
            //The action on "Ok" button
            alert.addAction(action)
            //show the alert
            self.presentViewController(alert, animated: true){}
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //create the custom cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamsCC", forIndexPath: indexPath) as! TeamsCC
        
        let row = indexPath.row
        
        let teamObject = self.teamsArray[row] as PFObject
        
        //get the team name and team Image and set them
        let teamName = teamObject.objectForKey("Name") as! String
        cell.teamName.text = teamName

        let teamImage = teamObject.objectForKey("Image") as! PFFile        
        teamImage.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
            let image: UIImage! = UIImage(data: imageData!)!
            cell.teamLogo.image = image
        })

        return cell
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamsArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }


    //method to pass data when segue is perform from one view to another view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        //checking which segue is performing
        if segue.identifier == "TeamGamesSegue" {
            
            
            //passing data from one view controller to another view controller
            let destinationVC = segue.destinationViewController as? TeamGamesViewController
                
            //getting the index of the selected row
            let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
                
            //getting the team name of the row that the user tapped
            let row = indexPath.row
            let teamObject = self.teamsArray[row] as PFObject
            
            let teamsName = teamObject.objectForKey("NameEN") as! String
            
            let teamsNameCup = teamObject.objectForKey("NameCupEN") as! String
            
            //passing the team name to the next view controller
            destinationVC!.dataTypeToLoad = teamsName
            
            //passing the team name to the next view controller
            destinationVC!.cupDataTypeToLoad = teamsNameCup
                
            //deselect the row you press when you go back
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
        }
    }


}
