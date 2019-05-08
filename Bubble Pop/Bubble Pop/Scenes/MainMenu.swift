//
//  MainMenu.swift
//  Bubble Pop
//
//  Created by Jhon Stewar Rayo Mosquera on 17/4/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenu: SKScene {
    
    var playButtonNode: SKSpriteNode! = nil
    var leaderboardButtonNode: SKSpriteNode! = nil
    var settingsButtonNode: SKSpriteNode! = nil
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        addButtons()
    }
    
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
    }
    
    func animate(button: SKSpriteNode) {
        let zoomIn = SKAction.resize(byWidth: 5.0, height: 5.0, duration: 0.5)
        let zoomOut = SKAction.resize(byWidth: -5.0, height: -5.0, duration: 0.5)
        let zoomSequence = SKAction.sequence([zoomIn, zoomOut])
        button.run(SKAction.repeatForever(zoomSequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: self)
            let viewController = UIApplication.shared.keyWindow?.rootViewController!
            if playButtonNode.contains(loc) {
                let gameScene = GameScene(size: view!.bounds.size)
                view!.presentScene(gameScene)
            }
            else if leaderboardButtonNode.contains(loc) {
                viewController?.performSegue(withIdentifier: "leaderboardSegue", sender: nil)
            } else if settingsButtonNode.contains(loc) {
                viewController?.performSegue(withIdentifier: "settingsSegue", sender: self)
            }
        }
    }
}
