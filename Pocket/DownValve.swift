//
//  DownValve.swift
//  padpod
//
//  Created by Arthur Berman on 2/9/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

import Foundation
import UIKit

class DownValve : UIView, PdListener {
    var pullDown : ValveHead? // the view
    var dragging : Bool? //whether we are currently dragging
    var oldPos : CGPoint? // where we started to drag
    var value  = 0.0 // the current value of the slider
    var sendChange : (Double -> ())? // the function called every time the slider is moved
    var sendTap : (Double -> ())? // the function called every time the slider is tapped
    var curVal : Int = 60
    var selfLabel : UILabel?
    var pinchRecognizer : UIPinchGestureRecognizer?
    var returning : Bool = true
    let sliderColor = UIColor(red:89/255, green:138/255, blue:190/255, alpha:1.0)
    
    // the convenience initializer should be used, as it includes necessary data for the slider's performance
    convenience init(frame fr :CGRect, changed c : (Double -> ())?, tapped t : (Double -> ())?, note val : Int) {
        self.init(frame: fr)
        self.dragging = false
        self.sendChange = c
        self.sendTap = t
        self.curVal = val
        self.selfLabel = UILabel(frame: CGRectMake(50, 50, 100, 100))
        self.selfLabel!.textColor = sliderColor
        self.addSubview(self.selfLabel!)
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("pinch:"))
        self.addGestureRecognizer(pinchRecognizer!)
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.04, target: self, selector: Selector("update"), userInfo: nil, repeats: true)

        
    }
    func update() {
        if (self.dragging != true && self.returning) {
            dragSlider(pullDown!.frame!.origin.y - 5)
        }
    }
    func getValue() -> Double {
        return self.value
    }
    // Do not use this initializer unless you know what you're doing.
    override init(frame fr : CGRect ){
        super.init(frame: fr)
        pullDown = ValveHead(frame: CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: fr.width, height: 80)))
        self.dragging = false
    }
    // Do not use this initializer unless you know what you're doing.
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.dragging = false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        let t  = touches.first as! UITouch
        if (CGRectContainsPoint(pullDown!.frame!, t.locationInView(self)) ){
            self.dragging = true
            self.oldPos = t.locationInView(self)
            self.returning = false
            
            
        } else if (t.locationInView(self).y < self.frame.height/5) {
            self.value = 0
            self.sendChange?(self.value)
            pullDown!.frame!.origin.y = 0
            setNeedsDisplay()
        }
        else {
            self.returning = true
            
            self.dragSlider(t.locationInView(self).y)
        }
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (dragging!) {
            let t = touches.first as! UITouch
            dragSlider(t.locationInView(self).y)
            /*pullDown!.frame!.origin.y = t.locationInView(self).y
            pullDown!.frame!.origin.y = max(pullDown!.frame!.origin.y, 0) // limit the slider to non negative values
            pullDown!.frame!.origin.y = min(pullDown!.frame!.origin.y, self.frame.height - pullDown!.frame!.height) // limit the slider to within the parent view.
            self.value = Double(t.locationInView(self).y/self.frame.height);
            println(self.frame.height);
            self.value = (self.value > 0.01 ? self.value : 0)
            self.sendChange?(self.value)
            self.setNeedsDisplay()*/
        }
        
    }
    func dragSlider(y : CGFloat) {
        
            pullDown!.frame!.origin.y = y
            pullDown!.frame!.origin.y = max(pullDown!.frame!.origin.y, 0) // limit the slider to non negative values
            pullDown!.frame!.origin.y = min(pullDown!.frame!.origin.y, self.frame.height - pullDown!.frame!.height) // limit the slider to within the parent view.
            self.value = Double(y/self.frame.height);
            self.value = (self.value > 0.01 ? self.value : 0)
            self.sendChange?(self.value)
            self.setNeedsDisplay()
    }
    var startSize : CGFloat = 0
    func pinch(sender : UIPinchGestureRecognizer) {
        switch( sender.state) {
        case (UIGestureRecognizerState.Began):
            startSize = frame.height;
        case (UIGestureRecognizerState.Changed):
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, startSize * sender.scale)
            break;
        default:
            break;
        }
    }
    
    func resetValve(){
        self.dragging = false
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextClearRect(context, rect)
        drawBox(context, boundedby: rect)
        self.pullDown!.drawSelf(context, boundedBy: pullDown!.frame!)
    }
    
    func drawBox (context : CGContextRef, boundedby rect : CGRect) {
        CGContextSetStrokeColorWithColor(context, sliderColor.CGColor)
        CGContextAddRect(context, rect)
        CGContextStrokePath(context)
    }
    
    func receiveSymbol(received: String, fromSource source: String!) {
        self.selfLabel!.text = String(received)
    }

    
}


