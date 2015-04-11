//
//  CustomTabControllerViewController.swift
//  Pocket
//
//  Created by Arthur Berman on 3/28/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

import UIKit

class CustomTabControllerViewController: UIViewController {
    @IBOutlet weak var tabBarView: UIView!
    var children : [UIViewController]?
    var curView  : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
