//
//  MaestroView.swift
//  Pocket
//
//  Created by Arthur Berman on 3/31/15.
//  Copyright (c) 2015 Arthur Berman. All rights reserved.
//

import UIKit
import Foundation
protocol MaestroDelegate {
    func getMaestroInstruments () -> [MaestroInstrument]?
}
class MaestroView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var maestroDelegate : MaestroDelegate?
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        if let instruments = self.maestroDelegate?.getMaestroInstruments() {
            let count : Int = instruments.count
            let width : Float = Float(rect.width) / Float(count)
            println(instruments)
            
            for (index, instrument) in enumerate(instruments) {
                let xpos = Float(index) * width
                let rectSpace = CGRectMake(CGFloat(xpos), 0, CGFloat(width), rect.height)
                instrument.draw(context, rect: rectSpace)
            }
        }
    }
    
    func setDelegate(delegate : MaestroDelegate) {
        self.maestroDelegate = delegate
    }
    
    
}
