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
    var isGameOver: Bool = true {
        willSet {
            if newValue {           // If isGameOver is true (newValue) show New Game label
                playGame.alpha = 1
            } else if !newValue {   // If isGameOver is false (opposite of newValue) hide New Game label
                playGame.alpha = 0
            }
        }
    }
    
    var playGame: SKLabelNode!
    
    var gameTimer: Timer?
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var shotsImage: SKSpriteNode!
    var shots = 3 {
        didSet {
            shotsImage.texture = SKTexture(imageNamed: "shots\(shots)")
        }
    }
    
    var reloadLabel: SKLabelNode!
    
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
        
        shotsImage = SKSpriteNode(imageNamed: "shots\(shots)")
        shotsImage.position = CGPoint(x: 700, y: 70)
        shotsImage.zPosition = 101
        addChild(shotsImage)
        
        reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
        reloadLabel.position = CGPoint(x: 840, y: 60)
        reloadLabel.zPosition = 101
        reloadLabel.fontSize = 22
        reloadLabel.text = "RELOAD!"
        reloadLabel.name = "reload"
        addChild(reloadLabel)
        
        playGame = SKLabelNode(fontNamed: "Chalkduster")
        playGame.fontColor = .green
        playGame.position = CGPoint(x: 512, y: 690)
        playGame.zPosition = 101
        playGame.fontSize = 77
        playGame.text = "New Game"
        playGame.name = "playGame"
        playGame.alpha = 1
        addChild(playGame)
        
        gameOverLabel = SKSpriteNode(imageNamed: "game-over")
        gameOverLabel.zPosition = 101
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.alpha = 0
        addChild(gameOverLabel)
    }
    
    @objc func startGame() {
        // Start to move the water on the background
        createStartingAnimation()
        
        // Reset initial parameters
        gameOverLabel.alpha = 0
        minute = 60
        shots = 3
        score = 0
        
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
            
            isGameOver.toggle() // false set to true
            
            // Display a GameOver image with fadeIn animation
            gameOverLabel.run(SKAction.fadeIn(withDuration: 1.5))
            
            // Game Over sound
            run(SKAction.playSoundFileNamed("gameOver", waitForCompletion: false))
            
        }
    }
    
    func spawnEnemy() {
        // if the game is over return and stop spwaning enemy
        guard !isGameOver else { return }
        
        // Randomized the spawn of the enemy on 1 random line out of 3
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
        
        // Set good or bad value
        if randomTarget == 0 {
            target.name = "badTarget"
        } else if randomTarget == 3 {
            target.name = "goldTarget"
        } else {
            target.name = "goodTarget"
        }
        
        let moveTargetSlowOnLine = SKAction.moveTo(x: -200, duration: 3)
        let moveTargetFastOnLine = SKAction.moveTo(x: -200, duration: 1)
        
        // Set speed and size of fast and slow target
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
        // Fisrt steps for take nodes where the user tapped
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        // If tappedNodes contains playGame label it will means restart the whole game
        if tappedNodes.contains(where: { $0.name == "playGame" }) {
            startGame()
            isGameOver.toggle() // true set to false
            return
        }
        
        // If tappedNodes contains reload node play reload sound and refill shots
        if tappedNodes.contains(where: { $0.name == "reload" }) {
            run(SKAction.playSoundFileNamed("reload", waitForCompletion: false))
            shots = 3
        } else {
            
            // If the node doesn't contain reload, shot only if you have at least 1 ammo
            if shots > 0 {
                run(SKAction.playSoundFileNamed("shot", waitForCompletion: false))
                shots -= 1
            } else {
                return
            }
        }
        
        // Evaluating if tapped a good target or a bad one or the reload label
        for node in tappedNodes {
            if node.name == "badTarget" {
                
                node.removeAllActions()
                node.run(SKAction.fadeOut(withDuration: 0.3))
                
                // if it's a bad one you loose half of the points
                if score > 0 {
                    score /= 2
                } else {
                    
                    // If you don't have any points you loose 1500 points
                    score -= 5000
                }
                
            } else if node.name == "goodTarget" {
                
                node.removeAllActions()
                node.run(SKAction.fadeOut(withDuration: 0.3))
                
                // If it's a good one you gain 100 points
                score += 100
                
            } else if node.name == "goldTarget" {
                
                node.removeAllActions()
                node.run(SKAction.fadeOut(withDuration: 0.3))
                
                // If it's gold one, your score multiplies by 5
                if score > 0 {
                    score *= 5
                } else {
                    
                    // If you don't have any points you gain 1500 points
                    score += 1500
                }
                
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
