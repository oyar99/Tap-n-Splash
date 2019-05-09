//
//  ViewController.swift
//  Bubble Pop
//
//  Created by Jhon Stewar Rayo Mosquera on 17/4/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import UIKit
import SpriteKit

//The main GameViewController for the game.
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            let scene = MainMenu(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        }
    }
}

