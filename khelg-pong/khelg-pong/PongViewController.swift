//
//  PongViewController.swift
//  khelg-pong
//
//  Created by Petar Mataic on 23/02/15.
//  Copyright (c) 2015 Jayway. All rights reserved.
//

import UIKit

class PongViewController: UIViewController {

    @IBOutlet weak var remotePlayerPaddleY: NSLayoutConstraint!
    @IBOutlet weak var localPlayerPaddleY: NSLayoutConstraint!
    @IBOutlet weak var ballY: NSLayoutConstraint!
    @IBOutlet weak var ballX: NSLayoutConstraint!

    var networkController: NetworkController?
}
