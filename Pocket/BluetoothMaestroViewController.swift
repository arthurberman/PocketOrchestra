//
//  BluetoothMaestroViewController.swift
//  Pocket
//
//  Created by Arthur Berman on 4/4/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

import Foundation
import UIKit
import CoreAudioKit
class BluetoothMaestroViewController: UIViewController {
    override func viewDidLoad() {
    }
    @IBAction func configureCentral (sender: UIButton!)
    {
        var vController = CABTMIDICentralViewController()
        
        var navController = UINavigationController(rootViewController: vController)
        
        // this will present a view controller as a popover in iPad and modal VC on iPhone
        vController.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("doneAction:"))
        
        
        var popC : UIPopoverPresentationController = navController.popoverPresentationController!;
        popC.permittedArrowDirections = .Any;
        popC.sourceRect = sender.frame;
        
        popC.sourceView = sender.superview;
        
        presentViewController(navController, animated:true, completion:nil)
    }
    
}
