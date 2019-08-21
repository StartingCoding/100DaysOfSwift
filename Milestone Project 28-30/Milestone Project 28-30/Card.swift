//
//  Card.swift
//  Milestone Project 28-30
//
//  Created by Loris on 8/20/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import Foundation
import UIKit

// State of the card
enum State {
    case down
    case up
}

class Card: UIImageView {
    
    // Configure based on state
    func create(facing state: State) {
        // Initial basic setup
        self.tag = 1
        self.frame.size = CGSize(width: 93, height: 130)
        self.layer.cornerRadius = 10
        
        if state == .down {
            self.alpha = 1
            self.isUserInteractionEnabled = true
            
            // Create content for the back of the card
            let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
            
            let img = renderer.image { ctx in
                self.backgroundColor = .blue
                
                // Create circle in center
                let circle = CGRect(x: (self.bounds.width / 2) - 25, y: (self.bounds.height / 2) - 25, width: 50, height: 50)
                ctx.cgContext.setFillColor(UIColor.cyan.cgColor)
                ctx.cgContext.setStrokeColor(UIColor.yellow.cgColor)
                ctx.cgContext.setLineWidth(4)
                
                ctx.cgContext.addEllipse(in: circle)
                ctx.cgContext.drawPath(using: .fillStroke)
                
                // Create diamond inside cirlce
                ctx.cgContext.move(to: CGPoint(x: 46, y: 45))
                ctx.cgContext.addLine(to: CGPoint(x: 56, y: 65))
                ctx.cgContext.addLine(to: CGPoint(x: 46, y: 84))
                ctx.cgContext.addLine(to: CGPoint(x: 36, y: 65))
                ctx.cgContext.addLine(to: CGPoint(x: 46, y: 45))
                
                ctx.cgContext.setFillColor(UIColor.blue.cgColor)
                ctx.cgContext.drawPath(using: .fillStroke)
                
                // Create small squares
                let smallSquareUpLeft = CGRect(x: 10, y: 10, width: 10, height: 12)
                ctx.cgContext.stroke(smallSquareUpLeft)
                
                let smallSquareUpRight = CGRect(x: 73, y: 10, width: 10, height: 12)
                ctx.cgContext.stroke(smallSquareUpRight)
                
                let smallSquareDownLeft = CGRect(x: 10, y: 105, width: 10, height: 12)
                ctx.cgContext.stroke(smallSquareDownLeft)
                
                let smallSquareDownRight = CGRect(x: 73, y: 105, width: 10, height: 12)
                ctx.cgContext.stroke(smallSquareDownRight)
            }
            
            // The image of the card will be the content created
            self.image = img
        } else if state == .up {
            self.transform = CGAffineTransform(scaleX: 0, y: 1)
            self.alpha = 0
            
            // Creating Content
            let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
            
            let img = renderer.image { ctx in
                self.backgroundColor = .white
                
                // Create the word
                let hello = "hello!"
                
                // Style of the word
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let attr : [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 22),
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: paragraphStyle
                ]
                
                let attrHello = NSAttributedString(string: hello, attributes: attr)
                
                attrHello.draw(with: CGRect(x: 0, y: 35, width: 93, height: 130), options: .usesLineFragmentOrigin, context: nil)
            }
            
            // The image of the card will be the content created
            self.image = img
        }
    }
    
}
