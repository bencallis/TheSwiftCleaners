//
//  DewarpViewController.swift
//  DysonWars
//
//  Created by Matthew Holgate on 08/09/2016.
//  Copyright © 2016 Ben Callis. All rights reserved.
//

import UIKit

class DewarpViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "placeholderView")
        let outImage = OpenCVWrapper.processImage(image)
        self.image.image = outImage

        
    }
}
