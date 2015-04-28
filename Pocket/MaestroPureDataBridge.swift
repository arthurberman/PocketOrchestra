//
//  MaestroPureDataBridge.swift
//  Pocket
//
//  Created by Arthur Berman on 4/4/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

import Foundation
let controller = PdAudioController()
var dispatcher = PdDispatcher()
var connected = false
var delegate : BluetoothViewController?
@objc
public class MaestroPuredataBridge {
    class func setupPD() {
        controller.configurePlaybackWithSampleRate(44100, numberChannels: 2, inputEnabled: true, mixingEnabled: true)
        
        controller.active = true
        PdBase.setDelegate(dispatcher)
        PdExternals.setup()
        PdBase.openFile("pocket.pd", path: NSBundle.mainBundle().resourcePath)
    }
    class func setDelegate(d : BluetoothViewController!) {
        delegate = d
        connected = true
    }
    class func sendNoteOn(channel : Int32, pitch : Int32, velocity : Int32) {
        if(connected) {
            delegate!.sendNote(channel, pitch: pitch, velocity: velocity)
            
        } else {
            println("sent note")
            PdBase.sendNoteOn(channel, pitch: pitch, velocity: velocity)
        }
    }
    class func sendNoteOff(channel : Int32, pitch : Int32) {
        
        if(connected) {
            delegate!.sendNote(channel, pitch:pitch, velocity: 0)
            
        } else {
            PdBase.sendNoteOn(channel, pitch: pitch, velocity: 0)
        }
    }
    
    class func sendControlChange(channel : Int32, controller: Int32, value: Int32) {
        
        if(connected) {
            delegate!.sendControlChange(channel, controller: controller, value: value)
            
        } else {
            PdBase.sendControlChange(channel, controller: controller, value: value)
        }
    }
    
}