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

class GameScene: SKScene {
    var buildings = [BuildingNode]()
    
    // Set up this variable so it's going to be easier accessing the scene or the controller of the game
    // Making a weak reference on at least one of the property so we can avoid strong reference cycle
    weak var viewController: GameViewController?
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
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
    
    func launch(angle: Int, velocity: Int) {
        
    }
    
}
