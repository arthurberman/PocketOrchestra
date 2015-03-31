//
//  Maestro.swift
//  Pocket
//
//  Created by Arthur Berman on 3/29/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

import UIKit

class Maestro: UIViewController {
    var instruments : [MaestroInstrument]?
    @IBOutlet var recordButton: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addInstrument(instrument : MaestroInstrument) {
        instruments?.append(instrument)
        self.view.setNeedsDisplay()
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
