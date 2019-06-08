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
    
    var target0: SKSpriteNode!
    
    var timeLabel: SKLabelNode!
    var minute = 60 {
        willSet {
            timeLabel.text = "\(newValue)"
        }
    }
    
    var gameOverLabel: SKSpriteNode!
    var isGameOver: Bool = false
    
    var gameTimer: Timer?
    
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
        curtainBackground.zPosition = 5
        addChild(curtainBackground)
        
        let grassTrees = SKSpriteNode(imageNamed: "grass-trees")
        grassTrees.position = CGPoint(x: 512, y: 440)
        grassTrees.size.width = view.frame.size.width
        grassTrees.zPosition = 1
        addChild(grassTrees)
        
        waterBg = SKSpriteNode(imageNamed: "water-bg")
        waterBg.position = CGPoint(x: 512, y: 280)
        waterBg.size.width = view.frame.size.width
        waterBg.zPosition = 2
        addChild(waterBg)
        
        waterFg = SKSpriteNode(imageNamed: "water-fg")
        waterFg.position = CGPoint(x: 512, y: 170)
        waterFg.size.width = view.frame.size.width
        waterFg.zPosition = 4
        addChild(waterFg)
        
        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel.position = CGPoint(x: 512, y: 60)
        timeLabel.zPosition = 6
        timeLabel.text = "60"
        timeLabel.fontSize = 44
        addChild(timeLabel)
        
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
        createEnemy()
        
        // If minute is zero, the time is over so invalidate the timer
        if minute == 0 {
            gameTimer?.invalidate()
            
            isGameOver = true
            
            // Display a GameOver image
            gameOverLabel = SKSpriteNode(imageNamed: "game-over")
            gameOverLabel.zPosition = 6
            gameOverLabel.position = CGPoint(x: 512, y: 384)
            gameOverLabel.alpha = 0
            gameOverLabel.run(SKAction.fadeIn(withDuration: 1))
            addChild(gameOverLabel)
        }
    }
    
    func createEnemy() {
        guard !isGameOver else { return }
        
        target0 = SKSpriteNode(imageNamed: "target0")
        target0.position = CGPoint(x: 960, y: 290)
        target0.zPosition = 3
        addChild(target0)
        
        let moveTargetOnLine = SKAction.moveTo(x: 0, duration: 1)
        target0.run(moveTargetOnLine)
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
