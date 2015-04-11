//
//  ValveHead.swift
//  padpod
//
//  Created by Arthur Berman on 2/20/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

import Foundation

class ValveHead  {
    let sliderColor = UIColor(red:112/255, green:173/255, blue:238/255, alpha:1.0)
    var frame : CGRect?
    init(frame: CGRect) {
        self.frame = frame
    }
    func drawSelf(context: CGContextRef, boundedBy rect: CGRect) {
        CGContextSetStrokeColorWithColor(context, sliderColor.CGColor)
        CGContextSetLineWidth(context, 5)
        CGContextMoveToPoint(context, self.frame!.width / 8, self.frame!.origin.y + self.frame!.height / 4)
        CGContextAddLineToPoint(context, self.frame!.width * 7 / 8, self.frame!.origin.y + self.frame!.height / 4)
        CGContextAddLineToPoint(context, self.frame!.width / 2, self.frame!.origin.y + self.frame!.height * 7 / 8)
        CGContextAddLineToPoint(context, self.frame!.width / 8, self.frame!.origin.y + self.frame!.height / 4)
        CGContextAddLineToPoint(context, self.frame!.width * 7 / 8, self.frame!.origin.y + self.frame!.height / 4)
        CGContextStrokePath(context)
    }
}