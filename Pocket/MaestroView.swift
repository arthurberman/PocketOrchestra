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
            println(self.maestroDelegate?.getMaestroInstruments())
            
            for instrument : MaestroInstrument in instruments {
                
                instrument.draw(context, rect: rect)
            }
        }
    }
    
    func setDelegate(delegate : MaestroDelegate) {
        self.maestroDelegate = delegate
    }
    
    
}
