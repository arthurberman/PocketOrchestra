//
//  RoundButton.swift
//  Pocket
//
//  Created by Arthur Berman on 3/29/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

import UIKit
import Foundation
@IBDesignable
class RoundButton: UIView {
    enum buttonState {
        case on
        case off
    }
    
        
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var state = buttonState.off
    var tapRecognizer = UITapGestureRecognizer()
    override func prepareForInterfaceBuilder() {
    }
    func initThings() {
        tapRecognizer.addTarget(self, action: Selector("handleTap:"))
        println("hi")
        self.addGestureRecognizer(tapRecognizer)
        self.opaque = false
        self.alpha = 1.0
        self.backgroundColor = UIColor .clearColor()
    }
    override init(frame fr: CGRect) {
        super.init(frame: fr)
        initThings()

    }
    func handleTap(sender: UITapGestureRecognizer) {
        println("hi")
        if sender.state == .Ended {
            toggleState()
        }
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initThings()
    }
    
    func toggleState() {
        state = (state == .off ? .on : .off)
        self.setNeedsDisplay()
    }
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        self.opaque = false
        CGContextClearRect(context, rect)
        if (state == .off) {
            CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
            CGContextFillEllipseInRect(context, rect)
        } else {
            
            CGContextSetFillColorWithColor(context, UIColor.blueColor().CGColor)
            CGContextFillRect(context, rect)
        }
        CGContextStrokePath(context)
        
        var path = CGPathCreateWithEllipseInRect(rect, nil)
        CGContextAddPath(context, path);
 
        CGContextClip(context)
    }

}
