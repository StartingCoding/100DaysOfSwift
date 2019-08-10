//
//  GameScene.swift
//  Project29
//
//  Created by Loris on 7/31/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var buildings = [BuildingNode]()
    
    // Set up this variable so it's going to be easier accessing the scene or the controller of the game
    // Making a weak reference on at least one of the property so we can avoid strong reference cycle
    weak var viewController: GameViewController?
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var currentPlayer = 1
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
        createPlayers()
        
        physicsWorld.contactDelegate = self
    }
    
    func createBuildings() {
        // Set up the starting point a little far left from the screen so it feels like there are more and more buildings.
        var currentX: CGFloat = -15
        
        // Create buildings until the end of the screen
        while currentX < 1024 {
            // Set up a size for the building with a random width having in mind the space for windows and a random height
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            // Set the starting point to the next building with margin of 2 points
            currentX += size.width + 2
            
            // Create the building with the randomize size and a red background that is gonna be replaced with a random color
            let building = BuildingNode(color: .red, size: size)
            // Core Graphics needs to have the center point of the building in order to draw it.
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            // Create all of the setup for the building:
            // - Give it a name
            // - Create an UIImage with Core Graphics with the randomized size of the building created here.
            // - Set up a PhysicsBody for the building
            // - Set the texture of the BuildingNode to be the final UIImage of CoreGraphics
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    func createPlayers() {
        // Set up player1
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        // Set up physics body
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        // Set up center point of drawing of player1
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
        
        // Set up player2
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        // Set up physics body
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        // Set up center point of drawing of player2
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }
    
    // Convert degrees to radians
    func deg2rag(degrees: Int) -> Double {
        return Double(degrees) * Double.pi / 180
    }
    
    func launch(angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10.0
        let radians = deg2rag(degrees: angle)
        
        // If a banana already exists, delete it
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        // Create a new banana
        // .usesPreciseCollisionDetection is used for better tracking little object
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            // Set up the origin point of the banana
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            // Animate player for banana throw
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.run(sequence)
            
            // Throw of banana
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            // Set up the origin point of the banana
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            // Animate player for banana throw
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player2.run(sequence)
            
            // Throw pf banana
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Create 2 bodies
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        // order the 2 bodies based on CollisionTypes rawValue
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Make sure that we have 2 objects with contacts
        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }
        
        // If the banana hits the building destroy a little part of it
        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        
        // If the banana hit a player, destroy that player
        if firstNode.name == "banana" && secondNode.name == "player1" {
            destroy(player: player1)
            viewController?.player2Score += 1
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2" {
            destroy(player: player2)
            viewController?.player1Score += 1
        }
        
    }
    
    func destroy(player: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        
        // Load a new GameScene after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // If the player has 3 points end the game
            if self.viewController?.player1Score == 3 || self.viewController?.player2Score == 3 {
                // Make the EndScene
                let endGame = GameOverScene(size: self.size)
                // Make GameViewController the viewController of the EndScene
                endGame.viewController = self.viewController
                // Connect the EndScene we've just created with the reference on GameViewController
                self.viewController?.endGame = endGame
                // Set up a transition to change scene
                let transition = SKTransition.doorway(withDuration: 1.5)
                // Make the current scene present the EndScene
                self.view?.presentScene(endGame, transition: transition)
            } else {
                // Make a new GameScene
                let newGame = GameScene(size: self.size)
                // Make the new GameScene viewController (aka GameViewController) our previously GameViewController
                newGame.viewController = self.viewController
                // Make the reference for the scene on our GameViewController the newGame (scene) we have created
                self.viewController?.currentGame = newGame
                
                //Make the lost player the currentPlayer of the next GameScene
                self.changePlayer()
                newGame.currentPlayer = self.currentPlayer
                
                // Set up a transition to display the new GameScene
                let transition = SKTransition.doorway(withDuration: 1.5)
                self.view?.presentScene(newGame, transition: transition)
            }
            
        }
    }
    
    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        
        viewController!.activatePlayer(number: currentPlayer)
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        // Damaged building
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        // Remove banana
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        // Change turn of player
        changePlayer()
    }
    
    // If the banana goes over the building, remove it and change player
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
    
}
