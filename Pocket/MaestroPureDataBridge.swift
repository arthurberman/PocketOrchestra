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
class MaestroPuredataBridge {
    class func setupPD() {
        controller.configurePlaybackWithSampleRate(44100, numberChannels: 2, inputEnabled: true, mixingEnabled: true)
        
        controller.active = true
        PdBase.setDelegate(dispatcher)
        PdBase.openFile("synth.pd", path: NSBundle.mainBundle().resourcePath)
    }
    class func sendNoteOn(channel : Int32, pitch : Int32, velocity : Int32) {
        PdBase.sendNoteOn(channel, pitch: pitch, velocity: velocity)
    }
}