//
//  PercussionViewController.swift
//  Pocket
//
//  Created by Joe Sanford on 4/25/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

import UIKit

class PercussionViewController: UIViewController {
    
    let path = NSBundle.mainBundle().resourcePath! + "/"
    
    
    required init(coder aDecoder: NSCoder) {
        
        // Add all patches in the main bundle to Pd's search path, set up externals (needed for [soundfonts])
        PdBase.addToSearchPath(NSBundle.mainBundle().resourcePath)
        
        super.init(coder: aDecoder)
        var file = "SC88Drumset.sf2"
        PdBase.sendList(["set", path + file], toReceiver: "soundfonts")
    }
    
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        MaestroPuredataBridge.sendNoteOn(34, pitch: 60, velocity: 100)
        //PdBase.sendList([60, 127], toReceiver: "soundfonts")
    }
    @IBAction func button2Pressed(sender: UIButton) {
        MaestroPuredataBridge.sendNoteOn(34, pitch: 50, velocity: 100)
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
