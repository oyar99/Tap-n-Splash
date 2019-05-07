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
    let minBubbles = 4
    var maxBubbles = SettingsManager.getNumberOfBubbles()
    var bubblesOnScreen = [Bubble]()
    
    var time = SettingsManager.getGameTime()
    var spawnRate: TimeInterval = 1.0
    var currentSpawnRate: TimeInterval = 0.0
    var updateTime: TimeInterval = 0.0
    
    var upperWall = 0.0
    let offsetBetweenBubbles: CGFloat = 20.0
    
    override func didMove(to view: SKView) {
        setupLabels()
        setupValues()
        setupPhysics()
        layoutScene()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        let delta = currentTime - updateTime
        
        currentSpawnRate += delta
        
        if currentSpawnRate > spawnRate {
            spawnBubbles()
            time -= 1
            updateTimeLabel()
            currentSpawnRate = 0.0
        }
        
        updateTime = currentTime
        
    }
    
    func spawnBubbles() {
        if bubblesOnScreen.count == 0 {
            let numOfBubbles = Int.random(in: minBubbles...maxBubbles)
            
            for _ in 0...numOfBubbles {
                initBubble()
            }
        } else {
            let numOfBubblesToRemove = Int.random(in: 1...bubblesOnScreen.count - 1)
            let randomIndices = (0...numOfBubblesToRemove).map{ _ in Int.random(in: 0..<bubblesOnScreen.count)}
            
        }
        
    }
    
    func initBubble() {
        var bubble:Bubble
        let image = Bubble.randomColor()
        bubble = Bubble(imageNamed: image.rawValue)
        bubble.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bubble.size = CGSize(width: 50, height: 50)
        bubble.name = "bubble"
        bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.size.width / 2)
        
        let minX = Double(bubble.size.width)
        let maxX = Double(frame.size.width - bubble.size.width)
        let minY = Double(bubble.size.height)
        let maxY = upperWall - Double(bubble.size.height)
        
        var validPoint = false
        var pos: CGPoint!
        while(!validPoint) {
            validPoint = true
            let x = Double.random(in: minX...maxX)
            let y = Double.random(in: minY...maxY)
            
            pos = CGPoint(x: x, y: y)
            
            for b in bubblesOnScreen {
                let dx = pos.x - b.position.x
                let dy = pos.y - b.position.y
                
                let distance = sqrt(pow(dx, 2) + pow(dy, 2))
                
                if distance <= (bubble.size.width / 2) + offsetBetweenBubbles {
                    validPoint = false
                    break
                }
            }
        }
        bubble.position = pos
        bubblesOnScreen.append(bubble)
        addChild(bubble)
        
        bubble.physicsBody?.velocity = CGVector(dx: 50, dy: -50)
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.friction = 0
        physicsWorld.contactDelegate = self
    }
    
    func setupValues() {
        time = time == 0 ? 60: time
        maxBubbles = maxBubbles == 0 ? 15:maxBubbles
    }
    
    func setupLabels() {
        let highscore = GameManager.getHighscore()
        highscoreLabel.text = "Highscore: \(highscore)"
        timeLabel.text = "\(time) secs"
        scoreLabel.text = "Score: \(score)"
    }
    
    func layoutScene() {
        backgroundColor = SKColor.white
        let box = SKSpriteNode(color: UIColor.lightGray, size: CGSize(width: frame.size.width, height: frame.size.height / 12))
        box.zPosition = 1
        box.position = CGPoint(x: 0, y: frame.size.height - 2 * box.size.height)
        box.anchorPoint = CGPoint(x: 0, y: 0)
        upperWall = Double(box.position.y)
        addChild(box)
        
        scoreLabel.fontName = "Baskerville-SemiBoldItalic"
        scoreLabel.fontSize = 18.0
        scoreLabel.position = CGPoint(x: 50, y: box.size.height / 3)
        box.addChild(scoreLabel)
        
        highscoreLabel.fontName = "Baskerville-SemiBoldItalic"
        highscoreLabel.fontSize = 18.0
        highscoreLabel.position = CGPoint(x: scoreLabel.position.x + scoreLabel.frame.size.width + 50, y: box.size.height / 3)
        box.addChild(highscoreLabel)
        
        let clockImage = SKSpriteNode(imageNamed: "clock")
        clockImage.position = CGPoint(x: highscoreLabel.position.x + highscoreLabel.frame.size.width,y: box.size.height / 2)
        box.addChild(clockImage)
        
        timeLabel.fontName = "Baskerville-SemiBoldItalic"
        timeLabel.fontSize = 18.0
        timeLabel.position = CGPoint(x: clockImage.position.x + clockImage.size.width + 30, y: box.size.height / 3)
        box.addChild(timeLabel)
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }
    
    func updateTimeLabel() {
        timeLabel.text = "\(time) secs"
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if let bubble = contact.bodyA.node?.name == "bubble" ? contact.bodyA.node as? SKSpriteNode: contact.bodyB.node as? SKSpriteNode{
            bubble.physicsBody?.velocity = CGVector(dx: -1 * (bubble.physicsBody?.velocity.dx)!, dy: -1 * (bubble.physicsBody?.velocity.dy)!)
        }
    }
}

