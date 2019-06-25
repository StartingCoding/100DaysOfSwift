//
//  GameScene.swift
//  Project23
//
//  Created by Loris on 6/23/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import SpriteKit
import AVFoundation

enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}

enum ForceBomb {
    case never, always, random
}

class GameScene: SKScene {
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    // Set up slices with SKShapeNode (you can draw anything you want at runtime)
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    
    // Set up slices of the user
    var activeSlicePoints = [CGPoint]()
    
    // Set up sound
    var isSwooshSoundActive = false
    var bombSoundEffect: AVAudioPlayer?
    
    var activeEnemies = [SKSpriteNode]()
    
    // Position code
    // random position bottom edge of the screen
    var randomBottomEdgePosition = CGPoint()
    
    // random spin velocity
    var randomSpinningVelocity = CGFloat()
    
    // random horizontal velocity based on position
    var randomHorizontalVelocity = Int()
    
    // random vertical velocity
    var randomVerticalVelocity = Int()
    
    // Time to popup enemies
    var popupTime = 0.9
    
    // Create the sequence
    var sequence = [SequenceType]()
    var sequencePosition = 0
    
    // Delay of every enemy of a chain
    var chainDelay = 3.0
    
    // Set the sequence queue (aka if we have work to do or not) to true beacuse in the DidMove method we're gonne toss enemy
    var nextSequenceQueued = true
    
    var isGameEnded = false
    var gameOverLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // The default gravity is -9.8 which is the same as the Earth
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        // Set the actual speed of time of the physics world
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        
        // create a sequence that is 8 normal case of SequenceType + 1001 random of this cases
        sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        
        for _ in 0 ... 1000 {
            if let nextSequence = SequenceType.allCases.randomElement() {
                sequence.append(nextSequence)
            }
        }
        
        // Start the first sequence of the game
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in self?.tossEnemies() }
    }
    
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
    }
    
    func createLives() {
        for i in 0 ..< 3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: 834 + (i * 70), y: 720)
            addChild(spriteNode)
            
            livesImages.append(spriteNode)
        }
    }
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = .white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    // Track every swipe (CGPoint) of the user and save them in activeSlicePoints, then draw line?
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // if the game is already ended return
        guard isGameEnded == false else { return }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        // redraw slice
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
        
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            if node.name == "enemy" || node.name == "swift" {
                // destroy enemy
                
                if node.name == "enemy" {
                    score += 1
                } else if node.name == "swift" {
                    score += 10
                }
                
                // Add a particle effect
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emitter.position = node.position
                    addChild(emitter)
                }
                
                // wipe the name of the penguin so it can't be sliced again
                node.name = ""
                
                // disable its physics so it won't fall
                node.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                // SKAction.group lets you execute animations in parallels
                let group = SKAction.group([scaleOut, fadeOut])
                
                let seq = SKAction.sequence([group, .removeFromParent()])
                node.run(seq)
                
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "bomb" {
                // destroy bomb
                
                guard let bombContainer = node.parent as? SKSpriteNode else { continue }
                
                // Add a particle effect
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
                    emitter.position = bombContainer.position
                    addChild(emitter)
                }
                
                // wipe the name of the penguin so it can't be sliced again
                node.name = ""
                
                // disable its physics so it won't fall
                bombContainer.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                // SKAction.group lets you execute animations in parallels
                let group = SKAction.group([scaleOut, fadeOut])
                
                let seq = SKAction.sequence([group, .removeFromParent()])
                bombContainer.run(seq)
                
                if let index = activeEnemies.firstIndex(of: bombContainer) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                endGame(triggeredByBomb: true)
            }
        }
    }
    
    func endGame(triggeredByBomb: Bool) {
        // if the game is already ended return
        guard isGameEnded == false else { return }
        
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        // stop bomb sound
        bombSoundEffect?.stop()
        bombSoundEffect = nil
        
        // Set life to be zero
        if triggeredByBomb {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.position = CGPoint(x: 512, y: 344)
        gameOverLabel.text = "GameOver"
        gameOverLabel.fontSize = 94
        gameOverLabel.zPosition = 4
        gameOverLabel.alpha = 0
        addChild(gameOverLabel)
        
        gameOverLabel.run(SKAction.fadeIn(withDuration: 0.4))
    }
    
    func playSwooshSound() {
        isSwooshSoundActive = true
        
        let randomNumber = Int.random(in: 1 ... 3)
        let swooshName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(swooshName, waitForCompletion: true)
        
        run(swooshSound) { [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
    
    // When the user finished the swipe let the swipe fade out
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    // When the user touch the screen we need to delete everything associated with the previous user swipe
    // so we can make another swipe on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // remove the previous swipe keeping the capacity of the array (optimization)
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        // add the start of the new swipe
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        // redraw slice
        redrawActiveSlice()
        
        // Remove fading of previous swipe
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        
        // Make slices visible again
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
    }
    
    func redrawActiveSlice() {
        // If we don't have at least 2 CGPoints we can't draw anything so we return
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        // If the slice contains more than 12 points we're gonna remove points so the line is not too long
        // removeFirst remove first CGPoint of the slice so the array has 12 CGPoint
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        // Create a new BezierPath with the starting point be the first element of activeSlicePoints
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        // Add straight lines for every point of the array creating a swipe
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        // the path of the swipe created to the SKShapeNode
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    
    func createEnemy(forceBomb: ForceBomb = .random) {
        
        let enemy: SKSpriteNode
        
        var enemyType = Int.random(in: 0...6)
        
        if forceBomb == .never {
            enemyType = 1
        } else if forceBomb == .always {
            enemyType = 0
        }
        
        if enemyType == 0 {
            // Create bomb
            // Create container for image and fuse
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            
            // create image bomb and added to enemy container
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            // if there is already a bomb sound playing, stop it
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            
            // Play sound of the bomb
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            
            if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
        } else if enemyType == 6 {
            // Create gold enemy
            enemy = SKSpriteNode(imageNamed: "swift")
            enemy.name = "swift"
            
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
        } else {
            // Create enemy
            enemy = SKSpriteNode(imageNamed: "penguin")
            enemy.name = "enemy"
            
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
        }
        
        // Position code
        // random position bottom edge of the screen
        randomBottomEdgePosition = CGPoint(x: Int.random(in: 64...960), y: -128)
        
        // random spin velocity
        randomSpinningVelocity = CGFloat.random(in: -3...3)
        
        // random vertical velocity
        randomVerticalVelocity = Int.random(in: 24...32)
        
        enemy.position = randomBottomEdgePosition
        
        // random horizontal velocity based on position
        if randomBottomEdgePosition.x < 256 {
            randomHorizontalVelocity = Int.random(in: 8...15)
        } else if randomBottomEdgePosition.x < 512 {
            randomHorizontalVelocity = Int.random(in: 3...5)
        } else if randomBottomEdgePosition.x < 768 {
            randomHorizontalVelocity = -Int.random(in: 3...5)
        } else {
            randomHorizontalVelocity = -Int.random(in: 8...15)
        }
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.angularVelocity = randomSpinningVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        if enemyType == 6 {
            enemy.physicsBody?.velocity = CGVector(dx: randomHorizontalVelocity * 70, dy: randomVerticalVelocity * 50)
        } else {
            enemy.physicsBody?.velocity = CGVector(dx: randomHorizontalVelocity * 40, dy: randomVerticalVelocity * 40)
        }
        
        addChild(enemy)
        activeEnemies.append(enemy)
    }
    
    func subtractLife() {
        lives -= 1
        
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        
        var life: SKSpriteNode
        
        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }
        
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        
        life.xScale = 1.3
        life.yScale = 1.3
        
        life.run(SKAction.scale(to: 1, duration: 0.1))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // if there are active enemies remove who is out of screen
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    node.removeAllActions()
                    
                    if node.name == "enemy" || node.name == "swift" {
                        node.name = ""
                        
                        subtractLife()
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    } else if node.name == "bombContainer" {
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                }
            }
        } else {
            // if there aren't eny active enemies and there is no more work to do (aka no sequence in the queue)
            // then toss enemy and tell that we are making some work (aka set the sequence queue to true)
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [weak self] in self?.tossEnemies() }
                
                nextSequenceQueued = true
            }
        }
        
        var bombCount = 0
        
        for node in activeEnemies {
            if node.name == "bombContainer" {
                bombCount += 1
                break
            }
        }
        
        if bombCount == 0 {
            // no bombs - stop the fuse sound!
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
    }
    
    func tossEnemies() {
        // if the game is already ended return
        guard isGameEnded == false else { return }
        
        // Incrementing popupTime, the delay of every enemy of the chain and the speed of time of the world to make to game harder overtime
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        
        // Toss enemies based on the sequence type
        // 1: create one penguing
        // 2: create one random enemy
        // 3: create two enemies - 1 penguin and 1 bomb
        // 4: create two random enemies
        // 5: create three random enemies
        // 6: create four random enemies
        // 7: create a chain of random enemies with an equal time delay between every item of the chain
        // 8: create a fast chain of random enemies with an equal time delay between every item of the normal chain but 2 times faster
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
            
        case .one:
            createEnemy()
            
        case .twoWithOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)
            
        case .two:
            createEnemy()
            createEnemy()
            
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .chain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [weak self] in self?.createEnemy() }
            
        case .fastChain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [weak self] in self?.createEnemy() }
        }
        
        // go over the next sequence
        sequencePosition += 1
        
        // set nextSequenceQueued to false so we can say that after all we the enemies we have created we don't have anymore work to do aka another sequence in the queue
        nextSequenceQueued = false
    }
    
}
