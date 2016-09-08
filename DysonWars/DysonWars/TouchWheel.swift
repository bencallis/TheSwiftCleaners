//
//  TouchWheel.swift
//  DysonWars
//
//  Created by Ben Callis on 08/09/2016.
//  Copyright © 2016 Ben Callis. All rights reserved.
//

import Foundation
import UIKit

class TouchWheel: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2 // make it a circle
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        let touch: UITouch = touches.first!
        let location = touch.locationInView(self)

        print("Touched began. Point:\(location)")
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        let touch: UITouch = touches.first!
        let location = touch.locationInView(self)
        
        print("Touched moved. Point:\(location)")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        let touch: UITouch = touches.first!
        let location = touch.locationInView(self)
        
        print("Touched ended. Point:\(location)")
    }
}
