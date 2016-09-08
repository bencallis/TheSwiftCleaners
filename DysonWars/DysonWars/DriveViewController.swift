//
//  DriveViewController.swift
//  DysonWars
//
//  Created by Nick on 08/09/2016.
//  Copyright © 2016 Ben Callis. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class DriveViewController : UIViewController {
    
    private lazy var motorConverter: MotorConvertor = {
        // lazy so we can access the touchWheel
        return  MotorConvertor(drivingView: self.touchWheel, robot: self.robot)
    }()
    

    private var robot: Robot = Robot(host: "192.168.1.112")

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var debugConsole: UITextView!
    @IBOutlet weak var touchWheel: TouchWheel!
    
    @IBAction func unwindToDriveViewControllerFromSettings(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTouchWheel()
        //        robot = Robot(host: "192.168.1.112")
        //        robot.setWheelVelocity(left: 1000, right: 1000)

    }
    
    private func configureTouchWheel() {
        touchWheel.delegate = self

    }

    private func refreshImageView() {
        
    }
    
}

extension DriveViewController: TouchWheelDelegate {
    
    func touchedPoint(point: CGPoint, sender: TouchWheel) {
        debugConsole.text = "touchedPoint \(point)"
        motorConverter.consumePoint(point)
    }
    
    func touchesEnded(sender sender: TouchWheel) {
        debugConsole.text = "touchesEnded"
        motorConverter.consumeUntouch()
    }
}