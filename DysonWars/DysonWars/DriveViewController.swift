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

class DriveViewController : UIViewController, RobotDelegate {
    
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
        robot.delegate = self
        robot.connect()

    }
    
    private func configureTouchWheel() {
        touchWheel.delegate = self

    }

    private func refreshImageView() {
        
    }

    func statsDidChange(stats: String) {
        debugString(stats)
    }
    
    private func debugString(debugString: String) {
        let newText = debugString + "\n" + debugConsole.text
        debugConsole.text = newText // todo may need to limit this?
        debugConsole.setContentOffset(CGPointZero, animated: false)
    }
}

extension DriveViewController: TouchWheelDelegate {
    
    func touchedPoint(point: CGPoint, sender: TouchWheel) {
        debugString("🕹\(point)")
        motorConverter.consumePoint(point)
    }
    
    func touchesEnded(sender sender: TouchWheel) {
        debugString("🕹End")
        motorConverter.consumeUntouch()
    }
}