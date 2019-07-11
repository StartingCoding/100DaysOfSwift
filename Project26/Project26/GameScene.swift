//
//  GameScene.swift
//  Project26
//
//  Created by Loris on 7/3/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var background: SKSpriteNode!
    var player: SKSpriteNode!
    
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var level = 1
    
    var isGameOver = false
    
    var teleportPositions = [CGPoint]()
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        play()
    }
    
    func loadLevel() {
        // Make an array of lines from a loaded level
        let lines = loadStringLevelByTxtFile().components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                createNodeLevelBy(letter, at: position)
            }
        }
    }
    
    // Trying to load level from txt files
    func loadStringLevelByTxtFile() -> String {
        guard let levelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            fatalError("Could not find level\(level).txt in the app bundle.")
        }
        
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level1.txt from the app bundle.")
        }
        
        return levelString
    }
    
    // Create a node level based on Characters
    // x = wall
    // v = vortex
    // s = star
    // f = finish
    // t = teleport
    // empty space = player can pass through it so do nothing
    func createNodeLevelBy(_ letter: Character, at position: CGPoint) {
        var node = SKSpriteNode()
        
        if letter == "x" {
            // load wall
            node = SKSpriteNode(imageNamed: "block")
            
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
            node.physicsBody?.isDynamic = false
        } else if letter == "v" {
            // load vortex
            node = SKSpriteNode(imageNamed: "vortex")
            node.name = "vortex"
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            
            node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
        } else if letter == "s" {
            // load star
            node = SKSpriteNode(imageNamed: "star")
            node.name = "star"
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            
            node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
        } else if letter == "f" {
            // load finish
            node = SKSpriteNode(imageNamed: "finish")
            node.name = "finish"
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            
            node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
        } else if letter == "t" {
            // load finish
            node = SKSpriteNode(imageNamed: "teleportA")
            node.name = "teleport"
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            
            node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            
            teleportPositions.append(position)
        } else if letter == " " {
            // this is an empyt space, do nothing
            return
        } else {
            fatalError("Unknown level letter: \(letter)")
        }
        
        node.position = position
        addChild(node)
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.name = "player"
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    // Little hack to simulate gravity with touch on display
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
        
        for node in nodes(at: location) {
            if node.name == "replay" {
                play()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
            if let currentTouch = lastTouchPosition {
                let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
                physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
            }
        #else
            if let accelerometerData = motionManager.accelerometerData {
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50 , dy: accelerometerData.acceleration.x * 50)
            }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let group = SKAction.group([move, scale])
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([group, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "teleport" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            
            let positionNodeRounded = CGPoint(x: node.position.x.rounded(), y: node.position.y.rounded())
            var positionPlayerAfterTeleport = CGPoint()
            
            if positionNodeRounded == teleportPositions[0] {
                positionPlayerAfterTeleport = teleportPositions[1]
            } else if positionNodeRounded == teleportPositions[1] {
                positionPlayerAfterTeleport = teleportPositions[0]
            }
            
            let moveDown = SKAction.move(to: node.position, duration: 0.25)
            let scaleDown = SKAction.scale(to: 0.0001, duration: 0.25)
            let groupDown = SKAction.group([moveDown, scaleDown])
            
            let repositionPlayer = SKAction.move(to: positionPlayerAfterTeleport, duration: 0.0001)
            
            let moveUp = SKAction.move(to: CGPoint(x: positionPlayerAfterTeleport.x + 64, y: positionPlayerAfterTeleport.y), duration: 0.25)
            let scaleUp = SKAction.scale(to: 1, duration: 0.25)
            let groupUp = SKAction.group([moveUp, scaleUp])
            
            let sequence = SKAction.sequence([groupDown, repositionPlayer, groupUp])
            
            player.run(sequence) { [weak self] in
                self?.isGameOver = false
                self?.player.physicsBody?.isDynamic = true
            }
        } else if node.name == "finish" {
            if level < 2 {
                goToNextLevel()
            } else {
                endGameLevel()
            }
        }
    }
    
    func goToNextLevel() {
        isGameOver = true
        
        // Wipe all node from the scene except background or scoreLabel
        for nodeToRemove in children {
            if !(nodeToRemove.name == "background" || nodeToRemove.name == "scoreLabel") {
                nodeToRemove.removeFromParent()
            }
        }
        
        level += 1
        
        loadLevel()
        createPlayer()
        
        isGameOver = false
    }
    
    func endGameLevel() {
        isGameOver = true
        
        removeAllChildren()
        
        let endGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        endGameLabel.position = CGPoint(x: 512, y: 384)
        //endGameLabel.zPosition = 2
        endGameLabel.fontSize = 88
        endGameLabel.text = "You Win"
        addChild(endGameLabel)
        
        let replayGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        replayGameLabel.name = "replay"
        replayGameLabel.fontSize = 88
        replayGameLabel.position = CGPoint(x: 512, y: 270)
        replayGameLabel.text = "Replay"
        replayGameLabel.fontColor = .red
        addChild(replayGameLabel)
    }
    
    func play() {
        removeAllChildren()
        
        background = SKSpriteNode(imageNamed: "background")
        background.blendMode = .replace
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.name = "background"
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        scoreLabel.name = "scoreLabel"
        addChild(scoreLabel)
        
        level = 1
        score = 0
        
        loadLevel()
        createPlayer()
        
        isGameOver = false
    }
    
}
