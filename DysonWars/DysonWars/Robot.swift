//
//  Robot.swift
//  DysonWars
//
//  Created by Matthew Holgate on 08/09/2016.
//  Copyright © 2016 Ben Callis. All rights reserved.
//

import Moscapsule

class Robot: NSObject {

    let client : MQTTClient

    init(host: String) {
        // set MQTT Client Configuration
        let mqttConfig = MQTTConfig(clientId: "cid", host: host, port: 1883, keepAlive: 60)

        mqttConfig.onPublishCallback = { messageId in
            NSLog("published (mid=\(messageId))")
        }
        mqttConfig.onMessageCallback = { mqttMessage in
            NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")
        }

        // create new MQTT Connection
        client = MQTT.newConnection(mqttConfig)

        //client.subscribe("#", qos: 2)
    }

    func setWheelVelocity(left left : Int, right : Int) {
        let payload = "{\"Left\":\(left), \"Right\":\(right)}"
        print (payload)
        client.publishString(payload, topic: "command/wheel_speed", qos: 2, retain: false)
    }

}
