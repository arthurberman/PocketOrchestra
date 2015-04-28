//
//  SeqButton.swift
//  sequenceui
//
//  Created by Laura Hofmann on 4/16/15.
//  Copyright (c) 2015 COMP150. All rights reserved.
//

import Foundation
import UIKit

class SeqButton: UIButton {
    var active : Bool = false
    
    
    func containsTouch(point: CGPoint) -> Bool {
        if (point.x > 0 && point.x < self.frame.width && point.y > 0 && point.y < self.frame.height) {
            return true
        }
        return false
    }
    
}
