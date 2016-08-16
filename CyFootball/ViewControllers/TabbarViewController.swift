
//  TabbarViewController.swift

import UIKit

class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //changing the tabbar color
        let color = UIColor(red: 2.0/255.0, green: 17.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        self.tabBar.barTintColor = color
        
        //change the title color to white
        self.tabBar.tintColor = UIColor.whiteColor()
        
        //Change Tabbar Background Color when Selected
        self.tabBar.selectionIndicatorImage = UIImage(named: "appColor")
    }
    
    /* Setting the Tabbar Height */
    override func viewWillLayoutSubviews() {
        var tabFrame: CGRect = self.tabBar.frame;
        tabFrame.size.height = 55;
        tabFrame.origin.y = self.view.frame.size.height - 55;
        self.tabBar.frame = tabFrame;

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
