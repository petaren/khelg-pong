//
//  NetworkController.swift
//  khelg-pong
//
//  Created by Petar Mataic on 23/02/15.
//  Copyright (c) 2015 Jayway. All rights reserved.
//

import Foundation

protocol NetworkControllerDelegate {
    func connectedToServer(networkController: NetworkController)
    func disconnectedFromServer(networkController: NetworkController)
    func receivedMessage(networkController: NetworkController, message: [String: AnyObject])
}

class NetworkController: NSObject {
    var delegate: NetworkControllerDelegate?
    var socket: SIOSocket?
    
    override init() {
        super.init()
    }
    
    init(delegate: NetworkControllerDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    func connectTo(url: NSURL) {
        let urlString = url.absoluteString!
        SIOSocket.socketWithHost(urlString) { (socket) -> Void in
            self.socket = socket
            
            socket.onConnect = {
                println("Connected")
            }
            
            socket.onDisconnect = {
                println("Disconnected")
            }
            
            socket.onError = { (err) -> Void in
                println("Error: \(err.description)")
            }
        }
    }
    
}