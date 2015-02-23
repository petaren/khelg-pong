//
//  NetworkController.swift
//  khelg-pong
//
//  Created by Petar Mataic on 23/02/15.
//  Copyright (c) 2015 Jayway. All rights reserved.
//

import Foundation

protocol NetworkControllerDelegate: class {
    func connectedToServer(networkController: NetworkController)
    func disconnectedFromServer(networkController: NetworkController)
    func receivedMessage(networkController: NetworkController, message: (player: String, text: String))
    func playerConnected(networkController: NetworkController, players: (player1: String, player2: String?))
}

class NetworkController: NSObject {
    weak var delegate: NetworkControllerDelegate?
    var socket: SIOSocket?
    var playerName = "Unnamed player"
    
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
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.connectedToServer(self)
                    return
                }

                self.setPlayerName(self.playerName)
            }
            
            socket.onDisconnect = {
                println("Disconnected")
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.disconnectedFromServer(self)
                    return
                }
            }
            
            socket.onError = { (err) -> Void in
                println("Error: \(err.description)")
            }

            socket.on("players") { (array) -> Void in
                println("\(array.description)")

                let rootObject = array.first as [String: AnyObject]
                let playersDict = rootObject["players"] as [String: String]
                let players = (player1: playersDict["player1"]!, player2: playersDict["player2"])

                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.playerConnected(self, players: players)
                    return
                }
            }

            socket.on("message") { (array) -> Void in
                println("\(array.description)")

                let rootObject = array.first as [String: String]

                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.receivedMessage(self, message: (player: rootObject["player"]!, text: rootObject["message"]!))
                    return
                }
            }
        }
    }

    func disconnect() {
        self.socket?.close()
        self.socket = nil
        self.delegate?.disconnectedFromServer(self)
    }

    private func setPlayerName(playerName: String) {
        let message = ["playername": playerName]
        self.socket?.emit("add player", args: [message])
    }

    func sendMessage(text: String) {
        let message = ["message": text]
        self.socket?.emit("message", args: [message])
    }

    func movePaddleTo(y: Int) {
        let message = ["paddle": ["x": 10, "y": y]]
        self.socket?.emit("move", args: [message])
    }
    
}