//
//  GameOverViewController.swift
//  Bubble Pop
//
//  Created by Jhon Rayo on 7/5/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupValues()
    }

    //Dismisses any view on top and goes back to the main menu.
    @IBAction func goToMainMenu(_ sender: Any) {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    //Sets up the values for the game run that just finished.
    func setupValues() {
        scoreLabel.text = "You scored \(GameData.player.score) points"
        highscoreLabel.text = "Highscore: \(GameManager.getHighscore())"
    }
}
