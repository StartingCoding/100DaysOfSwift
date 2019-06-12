//
//  GameScene.swift
//  Milestone Project 16-18
//
//  Created by Loris on 5/23/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var waterBg: SKSpriteNode!
    var waterFg: SKSpriteNode!
    
    var target: SKSpriteNode!
    
    var timeLabel: SKLabelNode!
    var minute = 60 {
        willSet {
            timeLabel.text = "\(newValue)"
        }
    }
    
    var gameOverLabel: SKSpriteNode!
    var isGameOver: Bool = false
    
    var gameTimer: Timer?
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.blendMode = .replace
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.size = view.frame.size
        addChild(background)
        
        let curtainBackground = SKSpriteNode(imageNamed: "curtains")
        curtainBackground.position = CGPoint(x: 512, y: 384)
        curtainBackground.size = view.frame.size
        curtainBackground.zPosition = 100
        addChild(curtainBackground)
        
        let grassTrees = SKSpriteNode(imageNamed: "grass-trees")
        grassTrees.position = CGPoint(x: 512, y: 440)
        grassTrees.size.width = view.frame.size.width
        grassTrees.zPosition = 2
        addChild(grassTrees)
        
        waterBg = SKSpriteNode(imageNamed: "water-bg")
        waterBg.position = CGPoint(x: 512, y: 280)
        waterBg.size.width = view.frame.size.width
        waterBg.zPosition = 4
        addChild(waterBg)
        
        waterFg = SKSpriteNode(imageNamed: "water-fg")
        waterFg.position = CGPoint(x: 512, y: 170)
        waterFg.size.width = view.frame.size.width
        waterFg.zPosition = 6
        addChild(waterFg)
        
        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel.position = CGPoint(x: 512, y: 60)
        timeLabel.zPosition = 101
        timeLabel.text = "60"
        timeLabel.fontSize = 44
        addChild(timeLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 120, y: 60)
        scoreLabel.zPosition = 101
        scoreLabel.fontSize = 44
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        startGame()
    }
    
    @objc func startGame() {
        // Start to move the water on the background
        createStartingAnimation()
        
        // Fire a timer every one second so it updates the label to display how many seconds remain and creates enemy
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(manageTime), userInfo: nil, repeats: true)
    }
    
    @objc func manageTime() {
        minute -= 1
        
        // Create enemy
        spawnEnemy()
        
        // If minute is zero, the time is over so invalidate the timer
        if minute == 0 {
            gameTimer?.invalidate()
            
            isGameOver = true
            
            // Display a GameOver image
            gameOverLabel = SKSpriteNode(imageNamed: "game-over")
            gameOverLabel.zPosition = 101
            gameOverLabel.position = CGPoint(x: 512, y: 384)
            gameOverLabel.alpha = 0
            gameOverLabel.run(SKAction.fadeIn(withDuration: 1))
            addChild(gameOverLabel)
        }
    }
    
    func spawnEnemy() {
        guard !isGameOver else { return }
        
        if Int.random(in: 1...2) == 1 {
            let numLine = Int.random(in: 1...3)
            
            if numLine == 1 {
                createEnemy(y: 290, zPos: 5)
            }
            
            if numLine == 2 {
                createEnemy(y: 400, zPos: 3)
            }
            
            if numLine == 3 {
                createEnemy(y: 510, zPos: 1)
            }
        }
    }
    
    func createEnemy(y: Int, zPos: Int) {
        let randomTarget = Int.random(in: 0...3)
        
        if randomTarget == 0 {
            target = SKSpriteNode(imageNamed: "target0")
        } else if randomTarget == 1 {
            target = SKSpriteNode(imageNamed: "target1")
        } else if randomTarget == 2 {
            target = SKSpriteNode(imageNamed: "target2")
        } else if randomTarget == 3 {
            target = SKSpriteNode(imageNamed: "target3")
        } else {
            target = SKSpriteNode(imageNamed: "target0")
        }
        
        // Set good bad value
        if randomTarget == 0 {
            target.name = "badTarget"
        } else {
            target.name = "goodTarget"
        }
        
        let moveTargetSlowOnLine = SKAction.moveTo(x: -200, duration: 3)
        let moveTargetFastOnLine = SKAction.moveTo(x: -200, duration: 1)
        
        // Set speed and size of fast target
        if randomTarget == 3 {
            target.xScale = 0.7
            target.yScale = 0.7
            target.run(moveTargetFastOnLine)
            target.position = CGPoint(x: 960, y: CGFloat(y - 20))
        } else {
            target.run(moveTargetSlowOnLine)
            target.position = CGPoint(x: 960, y: y)
        }
        
        target.zPosition = CGFloat(zPos)
        
        addChild(target)
    }
    
    func createStartingAnimation() {
        // Create steps of the animation
        let moveLineForward = SKAction.moveTo(x: 562, duration: 0.8)
        let moveLineBackward = SKAction.moveTo(x: 472, duration: 0.8)
        
        // Create forever animation for the first line
        let moveLineForeground = SKAction.sequence([moveLineForward, moveLineBackward])
        let moveLineForegroundForever = SKAction.repeatForever(moveLineForeground)
        waterFg.run(moveLineForegroundForever)
        
        // Create forever animation for the second line backward
        let moveLineBackground = SKAction.sequence([moveLineBackward, moveLineForward])
        let moveLineBackgroundForever = SKAction.repeatForever(moveLineBackground)
        waterBg.run(moveLineBackgroundForever)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        // Shot sound
        run(SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false))
        
        for node in tappedNodes {
            if node.name == "badTarget" {
                node.removeAllActions()
                node.run(SKAction.fadeOut(withDuration: 0.3))
            } else if node.name == "goodTarget" {
                node.removeAllActions()
                node.run(SKAction.fadeOut(withDuration: 0.3))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Remove every enemy that is out of the game
        for node in children {
            if node.position.x < -100 {
                node.removeFromParent()
            }
        }
    }
}
