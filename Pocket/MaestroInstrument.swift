//
//  MaestroInstrument.swift
//  Pocket
//
//  Created by Arthur Berman on 3/31/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

import UIKit
import Foundation
class MaestroInstrument: NSObject {
    var color : CGColor = UIColor.greenColor().CGColor
    var volume : Float = 1.0
    
    convenience init(color : CGColor) {
        self.init()
        self.color = color
        self.volume = 1.0
        
    }
    func draw(context : CGContext, rect: CGRect) {
        CGContextSetFillColorWithColor(context, color)
        CGContextFillRect(context, rect)
        CGContextStrokePath(context)
    }
    
}
