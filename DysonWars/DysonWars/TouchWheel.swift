//
//  TouchWheel.swift
//  DysonWars
//
//  Created by Ben Callis on 08/09/2016.
//  Copyright © 2016 Ben Callis. All rights reserved.
//

import Foundation
import UIKit


protocol TouchWheelDelegate {
    func touchedPoint(point: CGPoint, sender: TouchWheel)
    func touchesEnded(sender sender: TouchWheel)
}

class TouchWheel: UIView {
    
    var delegate: TouchWheelDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2 // make it a circle
        self.layer.borderColor = UIColor.redColor().CGColor
        self.layer.borderWidth = 2
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        let touch: UITouch = touches.first!
        let location = touch.locationInView(self)

        print("Touched began. Point:\(location)")
        delegate?.touchedPoint(location, sender: self)
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        let touch: UITouch = touches.first!
        let location = touch.locationInView(self)
        
        print("Touched moved. Point:\(location)")
        delegate?.touchedPoint(location, sender: self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        let touch: UITouch = touches.first!
        let location = touch.locationInView(self)
        
        print("Touched ended. Point:\(location)")
        delegate?.touchesEnded(sender: self)

    }
}
