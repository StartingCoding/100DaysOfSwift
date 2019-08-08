//
//  BuildingNode.swift
//  Project29
//
//  Created by Loris on 7/31/19.
//  Copyright © 2019 Loris. All rights reserved.
//
// Create a separate class in order to create building and make the code more readable
import SpriteKit
import UIKit

class BuildingNode: SKSpriteNode {
    // Storing the building, and its various state, as an UIImage
    var currentImage: UIImage!
    
    func setup() {
        name = "building"
        
        currentImage = drawBuilding(size: size)
        texture = SKTexture(image: currentImage)
        
        configurePhysics()
    }
    
    // Set up the physicsBody of the building in order to detect when it gets hit by a banana
    func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
    }
    
    // Make an UIImage of a building using Core Graphics
    func drawBuilding(size: CGSize) -> UIImage {
        // Create a renderer object using a specified size
        let renderer = UIGraphicsImageRenderer(size: size)
        
        // Render an image using the renderer object
        let img = renderer.image { ctx in
            // Set up the size of the building
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            // Set up a random color of the building
            let color: UIColor
            
            switch Int.random(in: 0...2) {
            case 0:
                color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case 1:
                color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
            default:
                color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }
            
            // draw the building using the size of the rect and fill it using the random color
            color.setFill()
            ctx.cgContext.addRect(rect)
            ctx.cgContext.drawPath(using: .fill)
            
            // Set up 2 different type of colors for windows (one with a light on and one with a light off)
            let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
            
            // with stride(from:to:by:) you can have a sequence from a starting point to an end point with a specific interval.
            for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
                for col in stride(from: 10, to: Int(size.width - 10), by: 40) {
                    // Randomize wich window has a light on or off
                    if Bool.random() {
                        lightOnColor.setFill()
                    } else {
                        lightOffColor.setFill()
                    }
                    
                    ctx.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
                }
            }
        }
        
        // return the building with an UIImage
        return img
    }
    
    // When a buiding is hit:
    // - take the currentImage of the building
    // - draw it in a new Core Graphics context
    // - convert the point of collision with a point in the context
    // - draw an ellipse with a .clear blendMode
    // - draw the final UIImage and save it in the currentImage
    // - re-configure its new physics
    func hit(at point: CGPoint) {
        // The convertedPoint is going to be:
        // - the center of the x of the building + the x of the point of contact (horizontal)
        // - the center of the y of the building + the y of the poit of contact with an absolute value (vertical)
        let convertedPoint = CGPoint(x: point.x + size.width / 2.0, y: abs(point.y - (size.height / 2.0)))
        print(point.x, point.y)
        print(size.width, size.height)
        print(convertedPoint.x, convertedPoint.y)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            currentImage.draw(at: .zero)
            
            ctx.cgContext.addEllipse(in: CGRect(x: convertedPoint.x - 32, y: convertedPoint.y - 32, width: 64, height: 64))
            ctx.cgContext.setBlendMode(.clear)
            ctx.cgContext.drawPath(using: .fill)
        }
        
        texture = SKTexture(image: img)
        currentImage = img
        
        configurePhysics()
    }
}
