//
//  NetworkController.swift
//  DysonWars
//
//  Created by Ben Callis on 08/09/2016.
//  Copyright © 2016 Ben Callis. All rights reserved.
//

import Foundation
import UIKit

enum Result<T> {
    case success(T)
    case failure(ErrorType)
}

class NetworkController {
    
    let session = NSURLSession.sharedSession()
    
    func requestRobotImage(baseURL baseURL: String, completion: Result<UIImage> -> Void) {
        let url = NSURL(string: "\(baseURL):8080/frame.jpg")!
        
        session.dataTaskWithURL(url) { (data, response, error) in
            if let data = data, image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(error!))
            }
            
        }.resume()
    
    }
    
}