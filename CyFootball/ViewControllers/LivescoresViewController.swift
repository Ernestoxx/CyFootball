//
//  LivescoresViewController.swift
//  CyFootball
//
//  Created by Andreas Panayi on 2/27/16.
//  Copyright © 2016 CyFootball. All rights reserved.
//

import UIKit
import Parse

class LivescoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var livescoresArray: [PFObject] = []
    var refreshControl: UIRefreshControl!

    
    enum teamGamesError {
        
        case CantFindTeamGames
        
    }
    
    enum imageError {
        
        case CantFindImage
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //---> Getting the Data From Parse
        getLivescoresDataFromParse()
        
        //seth the background image of the tableView
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "stad")
        self.tableView.backgroundView = imageView
        
        //pull down refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(LivescoresViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl) // not required when using UITableViewController
        
    }
    //pull down refresh
    func refresh(sender:AnyObject) {
        getLivescoresDataFromParse()
        self.refreshControl.endRefreshing()
    }

    override func viewWillAppear(animated: Bool) {
        getLivescoresDataFromParse()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLivescoresDataFromParse() {
        
        //writing a query, getting the cup data from the table Livescores
        let query = PFQuery(className: "Livescores")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (livescoresArray, error) -> Void in
            if error == nil {
                self.livescoresArray = livescoresArray! as [PFObject]
                self.tableView.reloadData()
            } else {
                print(error)
            }
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //create the custom cell
        let cell = tableView.dequeueReusableCellWithIdentifier("LivescoresCC", forIndexPath: indexPath) as! LivescoresCC
        
        let row = indexPath.row
        
        let teamGameObject = self.livescoresArray[row] as PFObject
        
        //saving the Name of the type.. First get the array and then make it string
        let matchDate = teamGameObject.objectForKey("Date") as! String
        let score = teamGameObject.objectForKey("Score") as! String
        let homeTeamName = teamGameObject.objectForKey("HomeTeamName") as! String
        let homeTeamLogo = teamGameObject.objectForKey("HomeTeamLogo") as! PFFile
        let awayTeamName = teamGameObject.objectForKey("AwayTeamName") as! String
        let awayTeamLogo = teamGameObject.objectForKey("AwayTeamLogo") as! PFFile
        let time = teamGameObject.objectForKey("Time") as! String
        
        //setting the data
        cell.homeTeamName.text = homeTeamName
        cell.awayTeamName.text = awayTeamName
        cell.time.text = time
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
        return livescoresArray.count
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
        let matchObject = self.livescoresArray[row] as PFObject
        
        //getting the objectId from parse for the specific game and assigning it
        //to the var matchID on the next view controller
        detailsVC?.matchID = matchObject.objectForKey("MatchID") as? String
        print(matchObject.objectId)

        
        //get the row of the array
        let menuObject = self.livescoresArray[row] as PFObject
        
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

