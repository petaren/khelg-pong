//
//  ViewController.swift
//  khelg-pong
//
//  Created by Petar Mataic on 23/02/15.
//  Copyright (c) 2015 Jayway. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NetworkControllerDelegate {
    
    @IBOutlet weak var playerNameField: UITextField!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var eventsTextView: UITextView!
    
    let url = NSURL(scheme: "ws", host: "localhost:3000", path: "/")!
    var netController: NetworkController?

    @IBAction func connect(sender: UIButton) {
        println("Attempting to connect")
        self.netController = NetworkController(delegate: self)
        self.netController?.playerName = self.playerNameField.text
        self.netController?.connectTo(self.url)
    }
    
    @IBAction func disconnect(sender: UIButton) {
        println("Attempting to disconnect")
        self.netController?.disconnect()
    }
    
    @IBAction func sendMessage(sender: UIButton) {
        println("Attempting to send message")
        self.netController?.sendMessage(self.inputField.text)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pong game" {
            let pongVC = segue.destinationViewController as PongViewController
        }
    }
    
    // MARK: NetworkControllerDelegate
    
    func connectedToServer(networkController: NetworkController) {
        self.eventsTextView.text = self.eventsTextView.text + "\nConnected" //Weird that it doesn't let me append using += operator.
    }
    
    func disconnectedFromServer(networkController: NetworkController) {
        self.eventsTextView.text = self.eventsTextView.text + "\nDisconnected" //Weird that it doesn't let me append using += operator.
    }
    
    func receivedMessage(networkController: NetworkController, message: (player: String, text: String)) {
        self.eventsTextView.text = self.eventsTextView.text + "\n\(message.player): \(message.text)"
    }

    func playerConnected(networkController: NetworkController, players: (player1: String, player2: String?)) {
        self.eventsTextView.text = self.eventsTextView.text + "\nPlayers connected:\n  Player1: \(players.player1)"

        if let p2 = players.player2 {
            self.eventsTextView.text = self.eventsTextView.text + "\n  Player2: \(players.player2)"
            self.navigationItem.rightBarButtonItem?.enabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }

    }
    
}

