//
//  GameScene.swift
//  Bubble Pop
//
//  Created by Jhon Rayo on 6/5/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let scoreLabel = SKLabelNode()
    let highscoreLabel = SKLabelNode()
    let nameLabel = SKLabelNode()
    let timeLabel = SKLabelNode()
    
    var score = 0
    let maxBubbles = SettingsManager.getNumberOfBubbles()
    var bubblesOnScreen = [Bubble]()
    
    let time = SettingsManager.getGameTime()
    var spawnRate: TimeInterval = 4.0
    let maxSpawnRate: TimeInterval = 2.0
    let stepRate: TimeInterval = 0.2
    var currentSpawnRate: TimeInterval = 0.0
    var updateTime: TimeInterval = 0.0
    
    override func didMove(to view: SKView) {
        setupLabels()
        layoutScene()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        let delta = currentTime - updateTime
        
        currentSpawnRate += delta
        
        if currentSpawnRate > spawnRate {
            spawnBubbles()
            currentSpawnRate = 0.0
            spawnRate -= stepRate
            if spawnRate < maxSpawnRate {
                spawnRate = maxSpawnRate
            }
        }
        
        
        updateTime = currentTime
    }
    
    func spawnBubbles() {
        print("new bubbles")
    }
    
    func setupLabels() {
        let highscore = GameManager.getHighscore()
        highscoreLabel.text = String(highscore)
        timeLabel.text = String(time)
        scoreLabel.text = "Score: \(score)"
    }
    
    func layoutScene() {
        backgroundColor = SKColor.white
        
        let clockImage = SKSpriteNode(imageNamed: "clock")
        clockImage.position = CGPoint(x: frame.midX,y: frame.midY)
        addChild(clockImage)
        
        //scoreLabel.fontName = "TimesNewRoman"
        scoreLabel.fontSize = 12.0
        scoreLabel.fontColor = UIColor.black
        scoreLabel.position = CGPoint(x: 20, y: 20)
        addChild(scoreLabel)
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }
}
