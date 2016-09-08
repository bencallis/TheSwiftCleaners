//
//  MotorConverter.swift
//  DysonWars
//
//  Created by Nick on 08/09/2016.
//  Copyright © 2016 Ben Callis. All rights reserved.
//

import Foundation
import UIKit

class MotorConvertor {
    
    let sensitivityThreshold = 60.0
    let speedRadius = 300.0
    let lowFactor = 20.0
    let highFactor = 40.0
    
    var drivingView: UIView
    var drivingViewCenter: CGPoint
    var viewLength: Double
    var lastPoint: CGPoint?
    var robot: Robot
    
    init(drivingView: UIView, robot: Robot) {
        self.drivingView = drivingView
        self.viewLength = drivingView.bounds.size.height < drivingView.bounds.size.width ?
            Double(drivingView.bounds.size.height) : Double(drivingView.bounds.size.width)
        self.drivingViewCenter = drivingView.center
        self.robot = robot
    }
    
    struct Geometry {
        var xOffset: Double
        var yOffset: Double
        var distance: Double
        var heading: Double
    }
    
    func computeGeometry(origin origin: CGPoint, destination: CGPoint) -> Geometry {
        let xOffset = Double(destination.x - origin.x)
        let yOffset = Double(destination.y - origin.y)
        let distance = sqrt(xOffset*xOffset + yOffset*yOffset)
        let heading = atan2(yOffset, xOffset)
        return Geometry(xOffset: xOffset, yOffset: yOffset, distance: distance, heading: heading)
    }
    
    func accept(drivePoint: CGPoint) -> Bool {
        guard let lastPoint = lastPoint else { return true }
        let diff = computeGeometry(origin: lastPoint, destination: drivePoint)
        return diff.distance > sensitivityThreshold
    }
    
    func consumePoint(drivePoint: CGPoint) {
        
        guard accept(drivePoint) else {
            print("Not accepting point: sensitivity threshold.")
            return
        }
        
        let geom = computeGeometry(origin: drivingViewCenter, destination: drivePoint)
        var leftMotor: Int = 0
        var rightMotor: Int = 0
        
        if geom.xOffset > 0 {
            
            
        }
        
        
        
        let driveFactor = geom.distance < speedRadius ? lowFactor : highFactor
        
        
        
        
    }
    
    func consumeUntouch() {
        print("Untouch!")
    }
    
    
    
    
}
