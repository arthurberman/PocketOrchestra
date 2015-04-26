//
//  ViewController.swift
//  padpod
//
//  Created by Arthur Berman on 1/30/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

import UIKit
class HydralysViewController: UIViewController, UIScrollViewDelegate, UIPickerViewDelegate {
    
    @IBOutlet weak var valveScroller: UIScrollView!
    
    let bridge = PdBridge()
    
    
    
    var sliders : [DownValve] = []
    var scales = ["Major","Minor","Blues","Pentatonic","Mixolydian","Diminished"]
    var current_scale = "Major"
    override func viewDidLoad() {
        super.viewDidLoad()
     //   bridge.initialize()
      //  bridge.play()
        
        
        // we can add an arbitrary number of sliders by changing the upper limit on the range
        for i in 1...10 {
            var slide = Int32(i)
            // we keep a list of the sliders
            sliders.append(
                DownValve(frame: CGRect(x:100 * (i - 1), y:50, width:90, height:400), changed:
                    { (x) -> () in
                        // we define an anonymous function/closure to connect the slider to the bridge
                        //self.bridge.sendFloat(Float(x), toReceive: "vol"+String(i)) // change the volume
                        //PdBase.sendNoteOn(0, pitch: Int32(i+60), velocity:  Int32(127 * x))
                    //self.bridge.sendBangTo("bang"+String(i)) // make sure the note is playing
                        //let veloc = (Int32 (Int(x * 127)))
                        let veloc = Int32(Int(round(x * 127)))
                        if (x > 0.01){
                            MaestroPuredataBridge.sendNoteOn(Int32(i + 9), pitch: 60+i, velocity:  veloc)
                        } else {
                            MaestroPuredataBridge.sendNoteOn(Int32(i + 9), pitch: 60+i, velocity:  0)
                        }
                        
                        
                    }, tapped: { (x) -> () in
                        }, note: 60)
            )
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        for v in sliders {
            self.valveScroller.addSubview(v)
        }
        bridge.addNewListener(sliders[0], withSource: "slider1")
        bridge.addNewListener(sliders[1], withSource: "slider2")
        bridge.addNewListener(sliders[2], withSource: "slider3")
        bridge.addNewListener(sliders[3], withSource: "slider4")
        bridge.addNewListener(sliders[4], withSource: "slider5")
        bridge.addNewListener(sliders[5], withSource: "slider6")
        bridge.addNewListener(sliders[6], withSource: "slider7")
        bridge.addNewListener(sliders[7], withSource: "slider8")
        bridge.addNewListener(sliders[8], withSource: "slider9")
        bridge.addNewListener(sliders[9], withSource: "slider10")
        valveScroller.contentSize.width = CGFloat(100 * sliders.count + 100)
        valveScroller.panGestureRecognizer.minimumNumberOfTouches = 3
        valveScroller.panGestureRecognizer.maximumNumberOfTouches = 3
        
        // Start with 100% volume, shimmer, filter, tremolo matching sliders
        MaestroPuredataBridge.sendControlChange(1, controller: 21, value: 100)

    }
    
    @IBAction func volumeSlider(sender: UISlider) {
    }
    
    @IBAction func mutePressed(sender: UISwitch) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
    
}

