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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var debugConsole: UITextView!
    
    @IBAction func unwindToDriveViewControllerFromSettings(segue: UIStoryboardSegue) {
    }
    
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
    
    private func refreshImageView() {
        
    }
    


}
