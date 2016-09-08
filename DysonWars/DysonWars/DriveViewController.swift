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
    
    private let networkController = NetworkController()
    
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
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(refreshImageView), userInfo: nil, repeats: true)

        refreshImageView()

    }
    
    private func configureTouchWheel() {
        touchWheel.delegate = self

    }

    @objc private func refreshImageView() {
        print("refreshImageView")

        networkController.requestRobotImage(baseURL: "http://192.168.1.112") { [weak self] (result) in
            guard let sSelf = self else {return}
            
            switch result {
            case .success(let image):
                let flippedImage = UIImage(CGImage: image.CGImage!, scale: 1.0, orientation: .DownMirrored)

                dispatch_async(dispatch_get_main_queue(), { 
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