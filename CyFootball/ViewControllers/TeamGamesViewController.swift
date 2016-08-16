//
//  TeamGamesViewController.swift
//  CyFootball
//
//  Created by Andreas Panayi on 12/28/15.
//  Copyright © 2015 CyFootball. All rights reserved.
//

import UIKit
import Parse

class TeamGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    var teamGamesArray: [PFObject] = []
    var dataTypeToLoad: String?
    var cupDataTypeToLoad: String?
    var refreshControl: UIRefreshControl!

    
    enum teamGamesError {
        
        case CantFindTeamGames
        
    }
    
    enum imageError {
        
        case CantFindImage
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTeamGamesDataFromParse()
        
        //set the background image of the tableView
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "stad")
        self.tableView.backgroundView = imageView
        
        //pull down refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(TeamGamesViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl) // not required when using UITableViewController
        
    }
    
    //pull down refresh
    func refresh(sender:AnyObject) {
        getTeamGamesDataFromParse()
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        getTeamGamesDataFromParse()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: UIBarButtonItem) {
        
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func segmentAction(sender: UISegmentedControl) {
        
        if self.segmentControl.selectedSegmentIndex == 0 {
            getTeamGamesDataFromParse()
        } else {
            getTeamGamesCupDataFromParse()
        }
        
    }
    
    func getTeamGamesDataFromParse() {
        
        //writing a query, getting data from the table TeamMatches
        let query = PFQuery(className: "TeamMatches")
        query.whereKey("MatchType", equalTo: dataTypeToLoad!)
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (teamGamesArray, error) -> Void in
            if error == nil {
                self.teamGamesArray = teamGamesArray! as [PFObject]
                self.tableView.reloadData()
            } else {
                print(error)
            }
        }
        
    }
    
    func getTeamGamesCupDataFromParse() {
        
        //writing a query, getting the cup data from the table TeamMatches
        let query = PFQuery(className: "TeamMatches")
        query.whereKey("MatchType", equalTo: cupDataTypeToLoad!)
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (teamGamesArray, error) -> Void in
            if error == nil {
                self.teamGamesArray = teamGamesArray! as [PFObject]
                self.tableView.reloadData()
            } else {
                print(error)
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //create the custom cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamGamesCC", forIndexPath: indexPath) as! TeamGamesCC
        
        let row = indexPath.row
        
        let teamGameObject = self.teamGamesArray[row] as PFObject
        
        //saving the Name of the type.. First get the array and then make it string
        let matchDate = teamGameObject.objectForKey("Date") as! String
        let score = teamGameObject.objectForKey("Score") as! String
        let homeTeamName = teamGameObject.objectForKey("HomeTeamName") as! String
        let homeTeamLogo = teamGameObject.objectForKey("HomeTeamLogo") as! PFFile
        let awayTeamName = teamGameObject.objectForKey("AwayTeamName") as! String
        let awayTeamLogo = teamGameObject.objectForKey("AwayTeamLogo") as! PFFile

        //setting the data for each team
        cell.homeTeamName.text = homeTeamName
        cell.awayTeamName.text = awayTeamName

        cell.matchDate.text = matchDate
        cell.score.text = score
        
        homeTeamLogo.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
            let image: UIImage! = UIImage(data: imageData!)!
            cell.homeTeamLogo.image = image
        })
        
        awayTeamLogo.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
            let image: UIImage! = UIImage(data: imageData!)!
            cell.awayTeamLogo.image = image
        })

        return cell
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamGamesArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //passing data from one view controller to another view controller
        let detailsVC = segue.destinationViewController as? MatchInfoViewController
        
        //getting the index of the selected row
        let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
        
        //getting the team name of the row that the user tapped
        let row = indexPath.row
        
        //setting the matchObject to the specific match row
        let matchObject = self.teamGamesArray[row] as PFObject
        
        //getting the objectId from parse for the specific game and assigning it
        //to the var matchID on the next view controller
        detailsVC?.matchID = matchObject.objectId
        
        //get the row of the array
        let menuObject = self.teamGamesArray[row] as PFObject
        
        //get again the data from parse
        let homeTeamLogo = menuObject.objectForKey("HomeTeamLogo") as! PFFile
        let awayTeamLogo = menuObject.objectForKey("AwayTeamLogo") as! PFFile
        
        //send the data to the next view controller
        detailsVC!.scores = menuObject.objectForKey("Score") as? String

        do {
            let imageData = try NSData(data: homeTeamLogo.getData())
            detailsVC!.homeTeamLogos = UIImage(data: imageData)
            
        } catch imageError.CantFindImage {
            print("Cant convert image")
        } catch {
            print("Error")
        }
        
        do {
            let imageData = try NSData(data: awayTeamLogo.getData())
            detailsVC!.awayTeamLogos = UIImage(data: imageData)
            
        } catch imageError.CantFindImage {
            print("Cant convert image")
        } catch {
            print("Error")
        }
        
        
        //deselect the row you press when you go back
        tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
        

    }

}
