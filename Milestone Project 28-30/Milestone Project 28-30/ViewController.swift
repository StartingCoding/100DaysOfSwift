//
//  ViewController.swift
//  Milestone Project 28-30
//
//  Created by Loris on 8/14/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let backCardView = Card()
    let frontCardView = Card()
    
    let secondBackCardView = Card()
    let secondFrontCardView = Card()
    
    override func loadView() {
        super.loadView()
        
        frontCardView.create(facing: .up)
        view.addSubview(frontCardView)
        
        backCardView.create(facing: .down)
        view.addSubview(backCardView)
        
        // Create second card
        secondFrontCardView.create(facing: .up)
        secondBackCardView.create(facing: .down)
        view.addSubview(secondFrontCardView)
        view.addSubview(secondBackCardView)
        
        // Adding a TapGestureRecognizer so we can detect tap on card
//        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(tapOnCard))
//        backCardView.addGestureRecognizer(gestureTap)
//        secondBackCardView.addGestureRecognizer(gestureTap)
        
        // Create constraints to the card (back and front)
        backCardView.translatesAutoresizingMaskIntoConstraints = false
        frontCardView.translatesAutoresizingMaskIntoConstraints = false
        
        secondBackCardView.translatesAutoresizingMaskIntoConstraints = false
        secondFrontCardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backCardView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 200),
            backCardView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            
            frontCardView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 200),
            frontCardView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            
            // Second card constraints
            secondBackCardView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 350),
            secondBackCardView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            
            secondFrontCardView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 350),
            secondFrontCardView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100)
            ])

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        // Do any additional setup after loading the view.
    }
    
    @objc func tapOnCard(cardTapped: UIView) {
        // Make sure the card was tapped
//        guard let cardTapped = sender.view else { return }
        
        // Let the back of the card disappear
        UIView.animate(withDuration: 0.4, animations: {
            cardTapped.transform = .identity
            cardTapped.transform = CGAffineTransform(scaleX: 0.1, y: 1)
            cardTapped.alpha = 0
        }) { finished in
            // When the is gone make the front appear
            UIView.animate(withDuration: 0.4, animations: {
                self.frontCardView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.frontCardView.alpha = 1
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.view?.tag == 1 {
                tapOnCard(cardTapped: touch.view!)
            }
        }
    }

}

