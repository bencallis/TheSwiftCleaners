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
    
    @IBOutlet weak var panaromaImage: UIImageView!
    private lazy var motorConverter: MotorConvertor = {
        // lazy so we can access the touchWheel
        return  MotorConvertor(drivingView: self.touchWheel, robot: self.robot)
    }()
    
    private let networkController = NetworkController()
    
    private lazy var robot: Robot = {
       return Robot(host: self.currentIP)
    }()

    private var currentIP = "192.168.1.112"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var debugConsole: UITextView!
    @IBOutlet weak var touchWheel: TouchWheel!
    
    @IBAction func unwindToDriveViewControllerFromSettings(segue: UIStoryboardSegue) {
        
        switch(segue.identifier, segue.sourceViewController) {
        case ("dismissSettings"?, let settingsVC as SettingsViewController):
            guard let ip = settingsVC.ipTextField.text else {return}
            currentIP = ip
            debugString("newIP:" + currentIP)
           self.resetStuff()
        default:
            break;
        }
    }
    
    private func resetStuff() {
        self.robot = Robot(host: currentIP)
        robot.delegate = self
        robot.connect()
        motorConverter = MotorConvertor(drivingView: self.touchWheel, robot: self.robot)
        debugString("Reset stuff")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTouchWheel()
        resetStuff()
        
        self.imageView.image = nil // dont show the placeholder
        refreshImageView()

        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(refreshImageView), userInfo: nil, repeats: true)
    }
    
    private func configureTouchWheel() {
        touchWheel.delegate = self
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier, segue.destinationViewController) {
        case ("settings"?, let navVC as UINavigationController):
            guard let settingsVC = navVC.topViewController as? SettingsViewController else {return}
            settingsVC.ipText = currentIP
        default:
            break;
        }
    }
    @objc private func refreshImageView() {
        print("refreshImageView")

        networkController.requestRobotImage(baseURL: "http://\(currentIP)") { [weak self] (result) in
            guard let sSelf = self else {return}
            
            switch result {
            case .success(let image):

                let cropRect = CGRectMake(154, 14, 426, 428)
                let croppedImage = CGImageCreateWithImageInRect(image.CGImage, cropRect)

                let flippedImage = UIImage(CGImage: croppedImage!, scale: 1.0, orientation: .DownMirrored)

                let panaromaImage = OpenCVWrapper.processImage(flippedImage)

                dispatch_async(dispatch_get_main_queue(), {
                    sSelf.panaromaImage.image = panaromaImage
                    sSelf.imageView.image = flippedImage
                    sSelf.statsDidChange("new image SUCCESS")

                })
            case .failure(let error):
                print("Image request error: \(error)")
                sSelf.statsDidChange("new image FAILED")

                break;
            }
            sSelf.refreshImageView()
        }
    }

    func statsDidChange(stats: String) {
//        debugString(stats) dont log too much noise

    }

    func didDisconnect() {
        debugString("Disconnected!!!!!")
        resetStuff()
    }
    
    func didConnect() {
        debugString("Connected!!!!!")
    }
    
    private func debugString(debugString: String) {
        let newText = debugString + "\n" + debugConsole.text

        if NSThread.isMainThread() {
            debugConsole.text = newText // todo may need to limit this?
            debugConsole.setContentOffset(CGPointZero, animated: false)
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.debugConsole.text = newText // todo may need to limit this?
                self.debugConsole.setContentOffset(CGPointZero, animated: false)
            })
        }

    }

    @IBAction func unwindToMain(sender:UIStoryboardSegue) {

    }

    @IBAction func gearChanged(sender: UISegmentedControl) {
        let gear = sender.selectedSegmentIndex
        let speed = (gear * 1000) + 1000
        motorConverter.maxValue = speed
        
        debugString("Speed change: \(speed)")
    }
    
    @IBAction func panoramaTapped(sender: AnyObject) {
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