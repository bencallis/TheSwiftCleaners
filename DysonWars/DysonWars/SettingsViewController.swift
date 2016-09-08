//
//  SettingsViewController.swift
//  DysonWars
//
//  Created by Ben Callis on 08/09/2016.
//  Copyright © 2016 Ben Callis. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var ipTextField: UITextField!
    
    var ipText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ipText = ipText {
            ipTextField.text = ipText
        }
    }
}