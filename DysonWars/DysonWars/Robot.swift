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
}

class Robot: NSObject {

    let host : String
    var client : MQTTClient?
    var latestValues : [String : String] = [:]
    weak var delegate : RobotDelegate?
    var lastPayload : String?

    init(host: String) {
        // set MQTT Client Configuration
        self.host = host
    }

    func connect() {
        let mqttConfig = MQTTConfig(clientId: "cid", host: self.host, port: 1883, keepAlive: 60)

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
        
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(Robot.heartbeat), userInfo: nil, repeats: true)
    }
    
    func sendSpeedPayload(payload: String) {
        guard let client = client else {
            return
        }
        
        client.publishString(payload, topic: "command/wheel_speed", qos: 2, retain: false)
    }

    func setWheelVelocity(left left : Int, right : Int) {
        let payload = "{\"Left\":\(left), \"Right\":\(right)}"
        lastPayload = payload
        sendSpeedPayload(payload)
    }
    
    func heartbeat() {
        guard let payload = lastPayload else {
            return
        }
        sendSpeedPayload(payload)
    }

}
