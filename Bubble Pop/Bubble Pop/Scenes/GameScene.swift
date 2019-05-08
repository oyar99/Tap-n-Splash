//
//  GameScene.swift
//  Bubble Pop
//
//  Created by Jhon Rayo on 6/5/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import SpriteKit
import UIKit
class GameScene: SKScene {
    
    let scoreLabel = SKLabelNode()
    let highscoreLabel = SKLabelNode()
    let nameLabel = SKLabelNode()
    let timeLabel = SKLabelNode()
    var clockImage = SKSpriteNode()
    let countdownLabel = SKLabelNode()
    
    let minBubbles = 4
    var maxBubbles = SettingsManager.getNumberOfBubbles()
    var bubblesOnScreen = [Bubble]()
    
    var time = SettingsManager.getGameTime()
    var spawnRate: TimeInterval = 1.0
    var currentSpawnRate: TimeInterval = 0.0
    var updateTime: TimeInterval = 0.0
    var isAnimating = false
    var isGameOver = false
    var iscountingDown = true
    
    
    var upperWall = 0.0
    let offsetBetweenBubbles: CGFloat = 20.0
    
    let bubbleSpeed: CGFloat = 200.0
    var counter = 3
    
    var score = 0
    var latestTappedColor:BubbleSprite?
    
    override func didMove(to view: SKView) {
        setupLabels()
        setupValues()
        setupPhysics()
        layoutScene()
        startCounter()
    }
    
    
    func startCounter() {
        countdownLabel.text = String(counter)
        countdownLabel.position = CGPoint(x: frame.minX, y: frame.minY)
        countdownLabel.fontSize = 10
        addChild(countdownLabel)
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    @objc func countdown() {
        if (counter > 0) {
            counter -= 1
            countdownLabel.text = String(counter)
            print(counter)
        } else {
            iscountingDown = false
            countdownLabel.removeFromParent()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if !iscountingDown {
            let delta = currentTime - updateTime
            
            currentSpawnRate += delta
            
            if currentSpawnRate > spawnRate {
                spawnBubbles()
                time -= 1
                updateTimeLabel()
                currentSpawnRate = 0.0
            }
            
            updateTime = currentTime
            
            if time < 10 && !isAnimating {
                animate(clockImage)
                isAnimating = true
            }
            
            if time == 0 && !isGameOver{
                gameOver()
                isGameOver = true
            }
        }
    }

    
    func gameOver() {
        if score > GameManager.getHighscore() {
            GameManager.saveHighscore(highscore: score)
        }
        var players = GameManager.getPlayers()
        GameData.player.score = score
        players.append(GameData.player)
        GameManager.savePlayers(players: players)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = UIApplication.shared.keyWindow?.rootViewController!
        let gameOverScene = storyboard.instantiateViewController(withIdentifier: "gameover")
        let mainMenu = MainMenu(size: view!.bounds.size)
        view?.presentScene(mainMenu)
        viewController?.present(gameOverScene, animated: true, completion: nil)
        
    }
    
    func animate(_ node: SKSpriteNode) {
        let zoomIn = SKAction.resize(byWidth: 5.0, height: 5.0, duration: 0.5)
        let zoomOut = SKAction.resize(byWidth: -5.0, height: -5.0, duration: 0.5)
        let zoomSequence = SKAction.sequence([zoomIn, zoomOut])
        node.run(SKAction.repeatForever(zoomSequence))
    }
    
    func spawnBubbles() {
        if bubblesOnScreen.count == 0 {
            let numOfBubbles = Int.random(in: minBubbles...maxBubbles)
            
            for _ in 0..<numOfBubbles {
                initBubble()
            }
        } else {
            let numOfBubblesToRemove = Int.random(in: 1...bubblesOnScreen.count)
            let randomIndices = (0...numOfBubblesToRemove).map{ _ in Int.random(in: 0..<bubblesOnScreen.count)}
            var removedbubbles = [Bubble]()
            var temp = [Bubble]()
            
            for i in randomIndices {
                removedbubbles.append(bubblesOnScreen[i])
            }
            
            for bubble in bubblesOnScreen {
                if !removedbubbles.contains(bubble) {
                    temp.append(bubble)
                }
            }
            
            bubblesOnScreen = temp
            
            for bubble in removedbubbles {
                bubble.removeFromParent()
            }
            
            let min = minBubbles - bubblesOnScreen.count < 0 ? 0 : minBubbles - bubblesOnScreen.count
            
            let numOfBubbles = Int.random(in: min...maxBubbles - bubblesOnScreen.count)
            
            for _ in 0..<numOfBubbles {
                initBubble()
            }
            
        }
        
    }
    
    func initBubble() {
        var bubble:Bubble
        let image:BubbleSprite = Bubble.randomColor()
        bubble = Bubble(imageNamed: image.rawValue)
        bubble.type = image
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
    
        applyVelocity(to: bubble)
    }
    
    func applyVelocity(to bubble: Bubble) {
        let randomDirectionX: CGFloat = Bool.random() ? 1.0 : -1.0
        let randomDirectionY: CGFloat = Bool.random() ? 1.0 : -1.0
        
        bubble.physicsBody?.velocity = CGVector(dx: bubbleSpeed * randomDirectionX, dy: bubbleSpeed * randomDirectionY)
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
        
        clockImage = SKSpriteNode(imageNamed: "clock")
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let pos = touch.location(in: self)
        let bubble: Bubble? = atPoint(pos) as? Bubble
        
        if let bubble = bubble {
            if bubble.type == latestTappedColor {
                score += (Int(round(Double(bubble.gamePoints) * 1.5)))
            } else {
                score += bubble.gamePoints
            }
            updateScoreLabel()
            let index = bubblesOnScreen.firstIndex(of: bubble)
            bubblesOnScreen.remove(at: index!)
            bubble.removeFromParent()
            let splash = SKSpriteNode(imageNamed: bubble.splash)
            splash.zPosition = -1
            splash.position = bubble.position
            splash.size = CGSize(width: 40, height: 40)
            addChild(splash)
            latestTappedColor = bubble.type
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if let bubble = contact.bodyA.node?.name == "bubble" ? contact.bodyA.node as? SKSpriteNode: contact.bodyB.node as? SKSpriteNode{
            bubble.physicsBody?.velocity = CGVector(dx: -1 * (bubble.physicsBody?.velocity.dx)!, dy: -1 * (bubble.physicsBody?.velocity.dy)!)
        }
    }
}

