//
//  ViewController.swift
//  khelg-pong
//
//  Created by Petar Mataic on 23/02/15.
//  Copyright (c) 2015 Jayway. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NetworkControllerDelegate {
    
    @IBOutlet weak var inputField: UITextField!
    
    let url = NSURL(scheme: "ws", host: "localhost:3000", path: "/")!
    var netController: NetworkController?

    @IBAction func connect(sender: UIButton) {
        println("Attempting to connect")
        self.netController = NetworkController(delegate: self)
        self.netController?.connectTo(self.url)
    }
    
    @IBAction func disconnect(sender: UIButton) {
        println("Attempting to disconnect")
//        self.netController?.disconnect()
    }
    
    @IBAction func sendMessage(sender: UIButton) {
        println("Attempting to send message")
//        self.netController?.sendMessage(self.inputField.text)
    }
    
    @IBAction func connectionStatus(sender: UIButton) {
//        println("Is connected: \(self.netController?.isConnected)")
    }
    
    // MARK: NetworkControllerDelegate
    
    func connectedToServer(networkController: NetworkController) {
        
    }
    
    func disconnectedFromServer(networkController: NetworkController) {
        
    }
    
    func receivedMessage(networkController: NetworkController, message: [String : AnyObject]) {
        
    }
    
}

