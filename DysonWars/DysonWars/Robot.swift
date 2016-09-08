//
//  Robot.swift
//  DysonWars
//
//  Created by Matthew Holgate on 08/09/2016.
//  Copyright © 2016 Ben Callis. All rights reserved.
//

import Moscapsule

protocol RobotDelegate:class {
    func statsDidChange(stats: String)
    func didDisconnect()
    func didConnect()

}

class Robot: NSObject {

    let host : String
    var client : MQTTClient?
    var latestValues : [String : String] = [:]
    weak var delegate : RobotDelegate?
    var timer : NSTimer?
    
    var lastPayload : String?
    var lastLeft : Int?
    var lastRight : Int?
    var targetLeft : Int?
    var targetRight : Int?

    init(host: String) {
        // set MQTT Client Configuration
        self.host = host
    }

    func connect() {
        let mqttConfig = MQTTConfig(clientId: "cid", host: self.host, port: 1883, keepAlive: 60)

        mqttConfig.onDisconnectCallback = { [weak self] reasonCode in
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                guard let sSelf = self else {
                    return
                }
                sSelf.timer?.invalidate()
                sSelf.timer = nil
                sSelf.delegate?.didDisconnect()
                sSelf.delegate = nil
            })
        }

        mqttConfig.onConnectCallback = { [weak self] reasonCode in
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                guard let sSelf = self else {
                    return
                }
                sSelf.delegate?.didConnect()
                })
        }
        mqttConfig.onPublishCallback = { messageId in
            //NSLog("published (mid=\(messageId))")
        }
        mqttConfig.onMessageCallback = { mqttMessage in
            //NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")

            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                guard let sSelf = self else {
                    return
                }

                sSelf.latestValues[mqttMessage.topic] = mqttMessage.payloadString
                guard let delegate = sSelf.delegate else {
                    return
                }
                delegate.statsDidChange(sSelf.latestValues.description)
            })
        }

        // create new MQTT Connection
        client = MQTT.newConnection(mqttConfig)

        guard let client = client else {
            return
        }

        client.subscribe("#", qos: 2)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(Robot.heartbeat), userInfo: nil, repeats: true)
    }
    
    func sendSpeedPayload(payload: String) {
        guard let client = client else {
            return
        }
        
        client.publishString(payload, topic: "command/wheel_speed", qos: 2, retain: false)
    }
    
    func sendSpeed(left left: Int, right: Int) {
        
        var smoothLeft = left
        var smoothRight = right
        
        if let lastLeft = lastLeft {
            smoothLeft = smoother(now: lastLeft, target: left)
        }
        
        if let lastRight = lastRight {
            smoothRight = smoother(now: lastRight, target: right)
        }
        
        let payload = "{\"Left\":\(smoothLeft), \"Right\":\(smoothRight)}"
        sendSpeedPayload(payload)
        print("smooth left: \(smoothLeft)")
        
        lastLeft = smoothLeft
        lastRight = smoothRight
    }
    
    func smoother(now now: Int, target: Int) -> Int {
        if abs(now - target) < 100 { return target }
        return now + Int(Double(target - now) * 0.3)
    }

    func setWheelVelocity(left left : Int, right : Int) {
        targetLeft = left
        targetRight = right
    }
    
    func heartbeat() {
        print("hb")
        guard let targetLeft = targetLeft, targetRight = targetRight else {
            return
        }
        print("tleft: \(targetLeft)")
        sendSpeed(left: targetLeft, right: targetRight)
    }

}
