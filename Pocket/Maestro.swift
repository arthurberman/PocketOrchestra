//
//  Maestro.swift
//  Pocket
//
//  Created by Arthur Berman on 3/29/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

import UIKit

class Maestro: UIViewController, MaestroDelegate, MaestroInstrumentDelegate {
    var instruments : [MaestroInstrument]! = []
    @IBOutlet var recordButton: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        (self.view as! MaestroView).setDelegate(self)
        MaestroPuredataBridge.setInstrumentDelegate(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addInstrumentSender"), name: "addInstrument", object: nil)
    }
    
    func volumeForChannel(channel : Int) -> Float{
        return 1.0
    }
    

    func addInstrumentSender() {
        addInstrument(MaestroInstrument(color: getRandomColor().CGColor))
    }
    @IBAction func addInstrumentButton(sender: AnyObject) {
        addInstrument(MaestroInstrument(color: getRandomColor().CGColor))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    func addInstrument(instrument : MaestroInstrument) {
        instruments.append(instrument)
        self.view.setNeedsDisplay()
        println("test")
    }
    
    func getMaestroInstruments() -> [MaestroInstrument]? {
        println("test2")
        return instruments
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
