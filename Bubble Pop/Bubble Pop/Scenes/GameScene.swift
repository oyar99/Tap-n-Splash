//
//  GameScene.swift
//  Bubble Pop
//
//  Created by Jhon Rayo on 6/5/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    let scoreLabel = SKLabelNode() //A label to show the score to the user.
    let highscoreLabel = SKLabelNode() //A label to show the highest score to the user.
    let timeLabel = SKLabelNode() //A label to show a the current time remaining before the game ends.
    var clockImage = SKSpriteNode() //A label to show a clock image
    let countdownLabel = SKLabelNode()
    
    let minBubbles = 4 //The minimum number of bubbles that will appear at start.
    var maxBubbles = SettingsManager.getNumberOfBubbles() //The maximum number of bubbles allowed on the screen.
    var bubblesOnScreen = [Bubble]() //List of current bubbles on screen.
    
    var time = SettingsManager.getGameTime() //The time the game will run for.
    var spawnRate: TimeInterval = 2.0 //The amount of time it takes to refresh bubbles on the screen.
    var currentSpawnRate: TimeInterval = 0.0 //The time it has elapsed since the bubbles were last refreshed.
    var currentElapsedTime: TimeInterval = 0.0 //The time it has elapsed since the last time the timer was updated.
    var updateTime: TimeInterval = 0.0 //The time the game has been running for.
    var isAnimating = false //Determines whether the clok image is animating or not.
    var isGameOver = false //Determines whether the game has finished or not.
    var isCountingDown = true //Determines whether the counter is still on screen or not.
    
    
    var upperWall = 0.0 //Upper limit of the screen.
    let offsetBetweenBubbles: CGFloat = 20.0 //The minimum distance between bubbles at spawn time.
    
    let bubbleSpeed: CGFloat = 200.0 //The bubbles speed
    var counter = 3 //Sets a counter
    
    var score = 0 //The current score
    var latestTappedColor:BubbleSprite? //The color of the most recent tapped bubble.
    
    //Initializes the scene
    override func didMove(to view: SKView) {
        setupLabels()
        setupValues()
        setupPhysics()
        layoutScene()
        countdown()
    }
    
    //Sets up the physics environment.
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.friction = 0
        physicsWorld.contactDelegate = self
    }
    
    //Sets up default values if neccesary.
    func setupValues() {
        time = time == 0 ? 60: time
        maxBubbles = maxBubbles == 0 ? 15:maxBubbles
    }
    
    //Sets up values for different labels.
    func setupLabels() {
        let highscore = GameManager.getHighscore()
        highscoreLabel.text = "Highscore: \(highscore)"
        timeLabel.text = "\(time) secs"
        scoreLabel.text = "Score: \(score)"
    }
    
    //Layouts the GUI components of the game scene.
    func layoutScene() {
        backgroundColor = SKColor.white
        let box = SKSpriteNode(color: UIColor.lightGray, size: CGSize(width: frame.size.width, height: frame.size.height / 12))
        box.zPosition = 1
        box.position = CGPoint(x: 0, y: frame.size.height - (2 * box.size.height))
        box.anchorPoint = CGPoint(x: 0, y: 0)
        upperWall = Double(box.position.y)
        addChild(box)
        
        scoreLabel.fontName = "Baskerville-SemiBoldItalic"
        scoreLabel.fontSize = 18.0
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: 50, y: box.size.height / 2)
        box.addChild(scoreLabel)
        
        highscoreLabel.fontName = "Baskerville-SemiBoldItalic"
        highscoreLabel.fontSize = 18.0
        highscoreLabel.verticalAlignmentMode = .top
        highscoreLabel.position = CGPoint(x: box.frame.midX, y: box.size.height / 2)
        box.addChild(highscoreLabel)
        
        timeLabel.fontName = "Baskerville-SemiBoldItalic"
        timeLabel.fontSize = 18.0
        timeLabel.verticalAlignmentMode = .top
        timeLabel.position = CGPoint(x: box.frame.maxX - 50, y: box.size.height / 2)
        box.addChild(timeLabel)
        
        clockImage = SKSpriteNode(imageNamed: "clock")
        clockImage.anchorPoint = CGPoint(x: 0.5, y: 0.8)
        clockImage.position = CGPoint(x: timeLabel.frame.minX - 15,y: box.size.height / 2)
        box.addChild(clockImage)
        
        countdownLabel.text = String(counter)
        countdownLabel.fontName = "Baskerville-SemiBoldItalic"
        countdownLabel.fontColor = UIColor.black
        countdownLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        countdownLabel.fontSize = 80
        addChild(countdownLabel)
    }
    
    //Starts the execution of count which runs every second.
    func countdown() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
    }
    
    //Counts from 3 to 1
    @objc func count() {
        counter -= 1
        if (counter > 0) {
            countdownLabel.text = String(counter)
        } else {
            countdownLabel.removeFromParent()
            isCountingDown = false
        }
    }
    
    //Runs every frame.
    override func update(_ currentTime: TimeInterval) {
        if !isCountingDown {
            let delta = currentTime - updateTime
            
            currentSpawnRate += delta
            currentElapsedTime += delta
            
            if currentSpawnRate > spawnRate {
                spawnBubbles()
                currentSpawnRate = 0.0
            }
            
            if currentElapsedTime > 1 {
                time -= 1
                updateTimeLabel()
                currentElapsedTime = 0.0
            }
            
            updateTime = currentTime
            
            removeBubblesOutOfScreen()
            
            if time < 10 && !isAnimating {
                animate(clockImage)
                isAnimating = true
            }
            
            if time == 0 && !isGameOver {
                gameOver()
                isGameOver = true
            }
        }
    }
    
    //Removes bubbles which have gone out of the screen.
    func removeBubblesOutOfScreen() {
        var temp = [Bubble]()
        for bubble in bubblesOnScreen {
            if bubble.position.y > CGFloat(upperWall) {
                bubble.removeFromParent()
            } else {
                temp.append(bubble)
            }
        }
        bubblesOnScreen = temp
    }

    //Finishes the current game run.
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
    
    //Applies a zoom-in zoom-out animation to the given node.
    func animate(_ node: SKSpriteNode) {
        let zoomIn = SKAction.resize(byWidth: 5.0, height: 5.0, duration: 0.5)
        let zoomOut = SKAction.resize(byWidth: -5.0, height: -5.0, duration: 0.5)
        let zoomSequence = SKAction.sequence([zoomIn, zoomOut])
        node.run(SKAction.repeatForever(zoomSequence))
    }
    
    //Spawn bubbles on the screen given certain criteria.
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
    
    //Spawn a single bubble on the screen
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
    
    //Changes the velocity of the given bubble
    func applyVelocity(to bubble: Bubble) {
        let randomDirectionX: CGFloat = Bool.random() ? 1.0 : -1.0
        let randomDirectionY: CGFloat = Bool.random() ? 1.0 : -1.0
        
        bubble.physicsBody?.velocity = CGVector(dx: bubbleSpeed * randomDirectionX, dy: bubbleSpeed * randomDirectionY)
    }
    
    //Updates the score label with the current score.
    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }
    
    //Updates the time label with the current remaining time.
    func updateTimeLabel() {
        timeLabel.text = "\(time) secs"
    }

    //Detects a touch on the screen and responds accordingly.
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

