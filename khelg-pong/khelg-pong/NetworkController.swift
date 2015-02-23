//
//  NetworkController.swift
//  khelg-pong
//
//  Created by Petar Mataic on 23/02/15.
//  Copyright (c) 2015 Jayway. All rights reserved.
//

import Foundation
import Starscream

protocol NetworkControllerDelegate {
    func connectedToServer(networkController: NetworkController)
    func disconnectedFromServer(networkController: NetworkController)
    func receivedMessage(networkController: NetworkController, message: [String: AnyObject])
}

class NetworkController: NSObject, WebSocketDelegate {
    var webSocket: WebSocket?
    var delegate: NetworkControllerDelegate?
    
    override init() {
        super.init()
    }
    
    init(delegate: NetworkControllerDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    var isConnected: Bool {
        return self.webSocket?.isConnected ?? false
    }
    
    func connectTo(url: NSURL) {
        self.webSocket?.delegate = nil
        self.webSocket = nil
        
        self.webSocket = WebSocket(url: url)
        self.webSocket?.delegate = self
        
        self.webSocket?.connect()
    }
    
    func sendMessage(message: String) {
        self.webSocket?.writeString(message)
    }
    
    func sendMessage(message:[String:AnyObject]) {
        var error: NSError?
        let messageData = NSJSONSerialization.dataWithJSONObject(message, options: NSJSONWritingOptions.allZeros, error: &error)
        
        if let e = error {
            println("There was an error serializing to JSON: \(e.description)")
        } else {
            self.webSocket?.writeData(messageData!)
        }
    }
    
    func disconnect() {
        self.webSocket?.disconnect()
        self.webSocket?.delegate = nil
        self.webSocket = nil
    }
    
    // MARK: StarScream WebSocketDelegate
    
    func websocketDidConnect(socket: WebSocket) {
        println("Connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        println("Disconnected: \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        println("Message: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        let s = NSString(data: data, encoding: NSUTF8StringEncoding)
        println("Data: \(s)")
    }
    
    
}