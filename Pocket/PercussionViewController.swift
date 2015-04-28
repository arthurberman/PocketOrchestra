//
//  PercussionViewController.swift
//  Pocket
//
//  Created by Joe Sanford on 4/25/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

//
//  ViewController.swift
//  sequenceui
//
//  Created by Joe Sanford on 3/29/15.
//  Copyright (c) 2015 Joe Sanford. All rights reserved.
//

import UIKit

class PercussionViewController: UIViewController {
    
    let xOffset = CGFloat(55)
    let yOffset = CGFloat(55)
    let instruments = ["Bass","Snare","Tom","Ride","Crash","Hi-Hat","Cowbell"]
    let outlineColor = UIColor(red:112/255, green:173/255, blue:238/255, alpha:1.0)
    let onColor = UIColor(red:109/255, green:232/255, blue:84/255, alpha:1.0)
    let offColor = UIColor(red:219/255, green:70/255, blue:70/255, alpha:1.0)
    let lineImage = UIImage(named: "scrubline.png") // make thicker
    
    var playing = false
    var x = CGFloat(100)
    var y = CGFloat(75)
    var currentNote = Float(0)
    var nextNote = Float(1)
    var timer = NSTimer()
    var scrubber = UISlider(frame:CGRectMake(100, 30, 870, 40))
    var tempo = Double(0.5)
    var timeInterval = Float (0.05)
    
    
    
    @IBOutlet var playPause: UIButton!
    @IBOutlet var tempoSlider: UISlider!
    @IBOutlet var collectionOfButtons: Array<SeqButton>!
    
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
        
        
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(tempo, target:self, selector: "scrubberMove", userInfo: nil, repeats: true)
        
        tempoSlider.minimumValue = 1
        tempoSlider.maximumValue = 3000
        tempoSlider.value = 1500
        scrubber.minimumValue = 0
        scrubber.maximumValue = 16
        scrubber.continuous = true
        scrubber.tintColor = outlineColor
        scrubber.value = 0
        scrubber.setThumbImage(lineImage, forState: UIControlState.Normal)
        self.view.addSubview(scrubber)
        
        playPause.addTarget(self, action: "playPauseAction:", forControlEvents: UIControlEvents.TouchUpInside)
        playPause.setTitleColor(onColor, forState: UIControlState.Normal)
        
        collectionOfButtons = Array<SeqButton>()
        
        for i in 0...6 {
            for j in 0...15 {
                let button = SeqButton()
                button.frame = CGRectMake(x, y, 45, 45)
                button.setTitle("", forState: UIControlState.Normal)
                button.backgroundColor = UIColor.clearColor()
                button.layer.cornerRadius = 5;
                button.layer.borderWidth = 1
                button.clipsToBounds = true;
                button.layer.borderColor = outlineColor.CGColor
                button.addTarget(self, action: "seqAction:", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(button)
                x += xOffset
                collectionOfButtons.append(button)
            }
            var label = UILabel(frame: CGRectMake(2, y, 95, 45))
            label.textAlignment = NSTextAlignment.Center
            label.textColor = outlineColor
            label.text = instruments[i]
            self.view.addSubview(label)
            x = CGFloat(100)
            y += yOffset
        }
        
        view.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 255)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for button in collectionOfButtons {
            var touched = false
            var cur_touch : UITouch = UITouch()
            for touch in event.allTouches()! {
                let t = touch as! UITouch
                var locationPoint = t.locationInView(button)
                if button.containsTouch(locationPoint) {
                    touched = true
                    cur_touch = t
                }
            }
            if (touched) {
                seqAction(button)
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for button in collectionOfButtons {
            var touched = false
            var cur_touch : UITouch = UITouch()
            for touch in event.allTouches()! {
                let t = touch as! UITouch
                var locationPoint = t.locationInView(button)
                if button.containsTouch(locationPoint) {
                    touched = true
                    cur_touch = t
                }
            }
            if (touched) {
                button.active = !(button.active)
                seqAction(button)
            }
        }
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func seqAction(sender:UIButton!) {
        if (sender.backgroundColor == UIColor.clearColor()){
            (sender as UIButton).backgroundColor = onColor
        }
        else {
            (sender as UIButton).backgroundColor = UIColor.clearColor()
        }
    }
    
    func playPauseAction(sender:UIButton!) {
        if playing {
            sender.setTitle("Play", forState: UIControlState.Normal)
            sender.setTitleColor(onColor, forState: UIControlState.Normal)
            playing = false
        }
        else {
            sender.setTitle("Stop", forState: UIControlState.Normal)
            sender.setTitleColor(offColor, forState: UIControlState.Normal)
            playing = true
            
        }
    }
    
    func scrubberMove() {
        if playing {
            currentNote = scrubber.value
            if(currentNote % 1 < timeInterval) {
                NoteOn(Int(currentNote))
            }
            if((currentNote > 0.74) && (currentNote - 0.75) % 1 < timeInterval){
                NoteOff(Int(floor(currentNote)))
            }
            
            nextNote = currentNote + timeInterval
            tempo = 60/Double(tempoSlider.value)
            timer.fireDate = timer.fireDate.dateByAddingTimeInterval(tempo)
            if (nextNote > 16){
                nextNote = 0
            }
            scrubber.setValue(nextNote, animated: true)
        }
    }
    
    
    func NoteOn(currNote: Int){
        println("NoteOn called")
        for i in 0...6 {
            if(collectionOfButtons[(i * 16) + currNote].backgroundColor == onColor) {
                MaestroPuredataBridge.sendNoteOn(34, pitch: 60, velocity: 100)
                NSLog("sendNoteOn %u", currNote)
                
            }
        }
    }
    
    func NoteOff(currNote: Int) { //currNote = note currently playing + 0.75
        println("NoteOff called")
        for i in 0...6 {
            if(collectionOfButtons[(i * 16) + currNote].backgroundColor == onColor) {
                if (i==0){
                    MaestroPuredataBridge.sendNoteOn(34, pitch: 60, velocity: 0) }
                else if (i==1) {
                    MaestroPuredataBridge.sendNoteOn(34, pitch: 68, velocity: 0)
                }
                NSLog("sendNoteOff %u", currNote)
            }
        }
    }
    
    @IBAction func clearAll(sender: UIButton) {
        for button in collectionOfButtons {
            button.active = false
            button.backgroundColor = UIColor.clearColor()
        }
        scrubber.value = 0
    }
    
}

//beats per minute feedback?
//
//each box .75 in width.
//each starts at whole int value
