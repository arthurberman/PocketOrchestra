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
var instrumentDelegate : MaestroInstrumentDelegate?
@objc
public class MaestroPuredataBridge {
    class func setupPD() {
        controller.configurePlaybackWithSampleRate(44100, numberChannels: 2, inputEnabled: true, mixingEnabled: true)
        
        controller.active = true
        PdBase.setDelegate(dispatcher)
        PdBase.openFile("synth2.pd", path: NSBundle.mainBundle().resourcePath)
    }
    class func setDelegate(d : BluetoothViewController!) {
        delegate = d
        connected = true
    }
    class func setInstrumentDelegate(d : MaestroInstrumentDelegate) {
        instrumentDelegate = d
    }
    class func sendNoteOn(channel : Int32, pitch : Int32, velocity : Int32) {
        if(connected) {
            delegate!.sendNote(0, pitch: pitch, velocity: velocity)
            
        } else {
            var vol : Float = 1.0
            if let d = instrumentDelegate {
                vol = d.volumeForChannel(Int(channel))
            }
            PdBase.sendNoteOn(channel, pitch: pitch, velocity: Int32(Float(velocity) * vol))
        }
    }
    class func sendNoteOff(channel : Int32, pitch : Int32) {
        
        if(connected) {
            delegate!.sendNote(0, pitch:pitch, velocity: 0)
            
        } else {
            PdBase.sendNoteOn(channel, pitch: pitch, velocity: 0)
        }
    }
}

protocol MaestroInstrumentDelegate {
    func volumeForChannel(i : Int) -> Float
}