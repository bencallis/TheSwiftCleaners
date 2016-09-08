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
    let slowSpeedRadius = 80.0
    
    var drivingView: UIView
    var drivingViewCenter: CGPoint
    var viewLength: Double
    var lastPoint: CGPoint?
    var robot: Robot
    
    init(drivingView: UIView, robot: Robot) {
        self.drivingView = drivingView
        self.viewLength = drivingView.bounds.size.height < drivingView.bounds.size.width ?
            Double(drivingView.bounds.size.height) : Double(drivingView.bounds.size.width)
        self.drivingViewCenter = CGPointMake(drivingView.bounds.size.width*0.5, drivingView.bounds.size.height*0.5)
        self.robot = robot
    }
    
    private struct Geometry {
        var xOffset: Double
        var yOffset: Double
        var distance: Double
        var heading: Double
    }
    
    private func computeGeometry(origin origin: CGPoint, destination: CGPoint) -> Geometry {
        let xOffset = Double(destination.x - origin.x)
        let yOffset = -1.0 * Double(destination.y - origin.y)
        let distance = sqrt(xOffset*xOffset + yOffset*yOffset)
        let heading = atan2(xOffset, yOffset)
        return Geometry(xOffset: xOffset, yOffset: yOffset, distance: distance, heading: heading)
    }
    
    private func accept(drivePoint: CGPoint) -> Bool {
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
        let slowTouch = geom.distance < slowSpeedRadius
        
        var left = 0
        var right = 0
        
        let headingDegrees = 180.0 * geom.heading / M_PI
        
        if abs(headingDegrees) < 15.0 {
            
            // Charge!
            left = 4000
            right = 4000
            
        } else if abs(headingDegrees) > 160.0 {
            
            // Retreat!
            left = -4000
            right = -4000
            
        } else {
        
            let activeWheel = 4000 // Int(abs(geom.heading) / M_PI * 4000.0)
            let passiveWheel = slowTouch ? -activeWheel : Int(Double(activeWheel) * 0.5)
            left = geom.heading < 0.0 ? passiveWheel : activeWheel
            right = geom.heading < 0.0 ? activeWheel : passiveWheel
            print("geometry: \(geom.xOffset) \(geom.yOffset) \(Int(geom.distance)) \(Int(180.0*geom.heading/M_PI))")
            
        }
        
        robot.setWheelVelocity(left: left, right: right)
        print("Robot driving: \(left) \(right)")
    }
    
    func consumeUntouch() {
        print("Untouch!")
        robot.setWheelVelocity(left: 0, right: 0)
        self.lastPoint = nil
    }
    
    
    
    
}
