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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view.
        let scene = DriveScene(size: self.view.bounds.size)
        scene.backgroundColor = UIColor.whiteColor()
        if let skView = self.view as? SKView {
            
            skView.showsFPS = true
            skView.showsNodeCount = true
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask  {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
