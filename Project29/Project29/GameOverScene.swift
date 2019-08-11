//
//  GameOverScene.swift
//  Project29
//
//  Created by Loris on 8/10/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    weak var viewController: GameViewController?
    
    var endGameLabel: SKLabelNode!
    
    var replayBtn: SKLabelNode!
    
    var winnerPlayer: Int!
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        self.viewController?.angleLabel.isHidden = true
        self.viewController?.angleSlider.isHidden = true
        
        self.viewController?.velocityLabel.isHidden = true
        self.viewController?.velocitySlider.isHidden = true
        
        self.viewController?.launchButton.isHidden = true
        
        self.viewController?.player1ScoreLabel.isHidden = true
        self.viewController?.player2ScoreLabel.isHidden = true
        
        self.viewController?.playerNumber.isHidden = true
        
        self.viewController?.windLabel.isHidden = true
        
        if self.viewController?.currentGame?.currentPlayer != nil {
            winnerPlayer = self.viewController?.currentGame?.currentPlayer
        }
        
        endGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        endGameLabel.position = CGPoint(x: 512, y: 384)
        endGameLabel.fontSize = 44
        endGameLabel.fontColor = .white
        endGameLabel.text = "Player \(winnerPlayer!) Wins"
        addChild(endGameLabel)
        
        replayBtn = SKLabelNode(text: "RePlay!")
        replayBtn.fontName = "Bold"
        replayBtn.fontColor = .white
        replayBtn.position = CGPoint(x: 512, y: 204)
        replayBtn.fontSize = 44
        replayBtn.name = "replay"
        addChild(replayBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node.name == "replay" {
                replay()
            }
        }
    }
    
    func replay() {
        endGameLabel.isHidden = true
        replayBtn.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController?.currentGame = newGame
            let transition = SKTransition.doorway(withDuration: 1)
            self.view?.presentScene(newGame, transition: transition)
            
            self.viewController?.player1Score = 0
            self.viewController?.player2Score = 0
            
            self.viewController?.currentGame?.currentPlayer = 1
            
            self.viewController?.angleLabel.isHidden = false
            self.viewController?.angleSlider.isHidden = false
            
            self.viewController?.velocityLabel.isHidden = false
            self.viewController?.velocitySlider.isHidden = false
            
            self.viewController?.launchButton.isHidden = false
            
            self.viewController?.player1ScoreLabel.isHidden = false
            self.viewController?.player2ScoreLabel.isHidden = false
            
            self.viewController?.playerNumber.isHidden = false
            
            self.viewController?.windLabel.isHidden = false
        }
    }
}
