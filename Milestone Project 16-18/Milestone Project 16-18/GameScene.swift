//
//  GameScene.swift
//  Milestone Project 16-18
//
//  Created by Loris on 5/23/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var target0: SKSpriteNode!
    
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
        
        let waterBg = SKSpriteNode(imageNamed: "water-bg")
        waterBg.position = CGPoint(x: 512, y: 280)
        waterBg.size.width = view.frame.size.width
        waterBg.zPosition = 2
        addChild(waterBg)
        
        let waterFg = SKSpriteNode(imageNamed: "water-fg")
        waterFg.position = CGPoint(x: 512, y: 170)
        waterFg.size.width = view.frame.size.width
        waterFg.zPosition = 3
        addChild(waterFg)
        
        target0 = SKSpriteNode(imageNamed: "target0")
        target0.position = CGPoint(x: 900, y: 290)
        target0.zPosition = 4
        addChild(target0)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
