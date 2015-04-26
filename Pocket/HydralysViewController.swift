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
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // key changing
    @IBAction func keyChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.bridge.sendString("Major", withArguments: [], toReceiver: "scalename");
        case 1:
            self.bridge.sendString("Minor", withArguments: [], toReceiver: "scalename");
        case 2:
            self.bridge.sendString("Blues", withArguments: [], toReceiver: "scalename");
        case 3:
            self.bridge.sendString("Pentatonic", withArguments: [], toReceiver: "scalename");
        case 4:
            self.bridge.sendString("Diminished", withArguments: [], toReceiver: "scalename");
        default:
            break;
        }
    }
    
    
    // master volume control and muting
    @IBOutlet var masterVolume: UISlider!
    
    @IBAction func masterVolumeSlider(sender: UISlider) {
        self.bridge.sendFloat(sender.value, toReceive: "mastervolume")
    }
    
    @IBAction func mutePressed(sender: UISwitch) {
        if sender.on {
            self.bridge.sendFloat(0, toReceive: "mastervolume")
        }
        
        else {
           self.bridge.sendFloat(masterVolume.value, toReceive: "mastervolume")
        }
        
    }

    // BP frequency control
    @IBAction func bpFreqSlider(sender: UISlider) {
        self.bridge.sendFloat(sender.value, toReceive: "filterfreq")
    }
    
    // phase control
    @IBAction func phaseSlider(sender: UISlider) {
        self.bridge.sendFloat(sender.value, toReceive: "phase")
    }
    
    // tremolo toggle
    @IBOutlet weak var tremoloSwitch: UISwitch!
    
    @IBAction func tremoloClicked(sender: UISwitch) {
        self.bridge.sendBangTo("tremolotoggle")
    }
    
    // tremolo control - slider value = tremolo rate
    @IBAction func tremoloSlider(sender: UISlider) {
        self.bridge.sendFloat(sender.value, toReceive: "tremolorate")
    }
    
    @IBAction func aNote(sender: AnyObject) {
        MaestroPuredataBridge.sendNoteOn(1, pitch: 57, velocity: 60)
    }
    @IBAction func bNote(sender: AnyObject) {
        MaestroPuredataBridge.sendNoteOn(0, pitch: 59, velocity: 60)
    }
    @IBAction func tremoloDepth(sender: UISlider){
        self.bridge.sendFloat(sender.value, toReceive: "tremolodepth")
    }
    
    // functions for PickerView for Scale
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scales.count
    }
    
    // On change of PickerView send new scale
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        self.bridge.sendString(scales[row], withArguments: [], toReceiver: "scalename")
        self.current_scale = scales[row]
        
        return scales[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        NSLog("Value Printing %@",scales[row]);
        
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView
    {
        var pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.lightGrayColor()
        pickerLabel.text = scales[row]
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 15) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        self.bridge.sendString(scales[row], withArguments: [], toReceiver: "scalename")
        return pickerLabel
    }
    
    
    @IBOutlet weak var rootControl: UISegmentedControl!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.bridge.sendFloat(Float(57), toReceive: "rootnote");
        case 1:
            self.bridge.sendFloat(Float(59), toReceive: "rootnote");
        case 2:
            self.bridge.sendFloat(Float(60), toReceive: "rootnote");
        case 3:
            self.bridge.sendFloat(Float(62), toReceive: "rootnote");
        case 4:
            self.bridge.sendFloat(Float(64), toReceive: "rootnote");
        case 5:
            self.bridge.sendFloat(Float(65), toReceive: "rootnote");
        case 6:
            self.bridge.sendFloat(Float(67), toReceive: "rootnote");
        default:
            break;
            
        }
        self.bridge.sendString(self.current_scale, withArguments: [], toReceiver: "scalename")
        var i = 1
        for v in sliders {
            var slide = Int32(i)
            if v.getValue() > 0 {
                self.bridge.sendBangTo("bang"+String(i))
                i++
            }
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
    
}

