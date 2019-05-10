//
//  MainMenu.swift
//  Bubble Pop
//
//  Created by Jhon Stewar Rayo Mosquera on 17/4/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    var playButtonNode: SKSpriteNode! = nil //A play button.
    var leaderboardButtonNode: SKSpriteNode! = nil //A scoreboard button.
    var settingsButtonNode: SKSpriteNode! = nil //A settings button.
    
    //Initializes the scene.
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        addButtons()
    }
    
    //Adds the buttons to the scene.
    func addButtons(){
        let colorTheme = ["Green", "Blue", "Grey","Purple"]
        let color = colorTheme[Int.random(in: 0..<colorTheme.count)]
        var playButton:String! = nil
        var leaderboardButton:String! = nil
        var settingsButton:String! = nil
        switch (color) {
        case "Green":
            playButton = "PlayGreen"
            leaderboardButton = "LeaderboardGreen"
            settingsButton = "SettingsGreen"
        case "Blue":
            playButton = "PlayBlue"
            leaderboardButton = "LeaderboardBlue"
            settingsButton = "SettingsBlue"
        case "Grey":
            playButton = "PlayGrey"
            leaderboardButton = "LeaderboardGrey"
            settingsButton = "SettingsGrey"
        case "Purple":
            playButton = "PlayPurple"
            leaderboardButton = "LeaderboardPurple"
            settingsButton = "SettingsPurple"
        default:
            break
        }
        playButtonNode = SKSpriteNode(imageNamed: playButton)
        playButtonNode.size = CGSize(width: frame.size.width / 5, height: frame.size.height / 10)
        playButtonNode.position = CGPoint(x: frame.midX, y: (frame.midY + frame.maxY) / 4)
        addChild(playButtonNode)
        animate(button: playButtonNode)
        leaderboardButtonNode = SKSpriteNode(imageNamed: leaderboardButton)
        leaderboardButtonNode.size = CGSize(width: frame.size.width / 5, height: frame.size.height / 10)
        leaderboardButtonNode.position = CGPoint(x: (frame.minX + playButtonNode.position.x) / 2, y: (frame.midY + frame.maxY) / 4)
        addChild(leaderboardButtonNode)
        animate(button: leaderboardButtonNode)
        settingsButtonNode = SKSpriteNode(imageNamed: settingsButton)
        settingsButtonNode.size = CGSize(width: frame.size.width / 5, height: frame.size.height / 10)
        settingsButtonNode.position = CGPoint(x: (frame.maxX + playButtonNode.position.x) / 2, y: (frame.midY + frame.maxY) / 4)
        addChild(settingsButtonNode)
        animate(button: settingsButtonNode)
        
        let logo = SKSpriteNode(imageNamed: "Logo")
        logo.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        addChild(logo)
    }
    
    //Animates the passed button.
    func animate(button: SKSpriteNode) {
        let zoomIn = SKAction.resize(byWidth: 5.0, height: 5.0, duration: 0.5)
        let zoomOut = SKAction.resize(byWidth: -5.0, height: -5.0, duration: 0.5)
        let zoomSequence = SKAction.sequence([zoomIn, zoomOut])
        button.run(SKAction.repeatForever(zoomSequence))
    }
    
    //Asks for the player name before a game run starts.
    func prepareSessionGame() {
        let alertController = UIAlertController(title: "Your name", message: "", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { texfield in
            texfield.placeholder = "Enter your name";
            texfield.textAlignment = .center
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Ready to play!", style: .default, handler: { _ in
            GameData.player = Player(name: (alertController.textFields?.first?.text!)!, score: 0)
            let gameScene = GameScene(size: self.view!.bounds.size)
            self.view!.presentScene(gameScene)
            })
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        let viewController = UIApplication.shared.keyWindow?.rootViewController!
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    //Handles the actions of the buttons.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: self)
            let viewController = UIApplication.shared.keyWindow?.rootViewController!
            if playButtonNode.contains(loc) {
                prepareSessionGame()
            }
            else if leaderboardButtonNode.contains(loc) {
                viewController?.performSegue(withIdentifier: "leaderboardSegue", sender: self)
            } else if settingsButtonNode.contains(loc) {
                viewController?.performSegue(withIdentifier: "settingsSegue", sender: self)
            }
        }
    }
}
