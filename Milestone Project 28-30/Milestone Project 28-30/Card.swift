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
        self.tag = 11
        self.frame.size = CGSize(width: 93, height: 130)
        self.layer.cornerRadius = 10
        
        if state == .down {
            
        } else if state == .up {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 1)
            
            // Creating Content
            let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
            
            let img = renderer.image { ctx in
                self.backgroundColor = .white
                
                let hello = "hello!"
                
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
