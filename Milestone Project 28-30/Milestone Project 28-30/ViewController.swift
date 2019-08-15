//
//  ViewController.swift
//  Milestone Project 28-30
//
//  Created by Loris on 8/14/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
// Card game photo
// https://unsplash.com/photos/IEISYENbXp8
    
    var backCard: UIImage!
    var backCardView: UIImageView!
    
    var frontCardView: UIImageView!
    
    override func loadView() {
        super.loadView()
        
        // Front card
        frontCardView = UIImageView()
        frontCardView.alpha = 0
        frontCardView.tag = 11
        frontCardView.frame.size = CGSize(width: 93, height: 130)
        frontCardView.layer.cornerRadius = 10
        frontCardView.transform = CGAffineTransform(scaleX: 0.01, y: 1)
        
        let renderer = UIGraphicsImageRenderer(bounds: frontCardView.bounds)

        let img = renderer.image { ctx in
            frontCardView.image?.draw(at: CGPoint(x: 0, y: 0))
            frontCardView.backgroundColor = .white
            
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
        
        frontCardView.image = img
        
        view.addSubview(frontCardView)
        
        frontCardView.translatesAutoresizingMaskIntoConstraints = false
        
        // Load one card into cache memory
        backCard = UIImage(named: "cardGame")
        
        // Create a view for the card
        backCardView = UIImageView()
        backCardView.alpha = 1
        backCardView.image = backCard
        backCardView.tag = 1
        backCardView.isUserInteractionEnabled = true
        view.addSubview(backCardView)
        
        // Create constraints to the card
        backCardView.translatesAutoresizingMaskIntoConstraints = false
        
        // Adding a TapGestureRecognizer so we can detect tap on card
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(tapOnCard))
        backCardView.addGestureRecognizer(gestureTap)

        NSLayoutConstraint.activate([
            backCardView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 200),
            backCardView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            
            frontCardView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 200),
            frontCardView.layoutMarginsGuide.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 108),
            frontCardView.widthAnchor.constraint(equalToConstant: 93),
            frontCardView.heightAnchor.constraint(equalToConstant: 130)
            ])

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        // Do any additional setup after loading the view.
    }
    
    @objc func tapOnCard(_ sender: UIGestureRecognizer) {
        // Make sure the card was tapped
        guard let cardTapped = sender.view else { return }
        
        // Let the back of the card disappear
        UIView.animate(withDuration: 0.5, animations: {
            cardTapped.transform = .identity
            cardTapped.transform = CGAffineTransform(scaleX: 0.25, y: 1)
            cardTapped.alpha = 0
        }) { finished in
            // When the is gone make the front appear
            UIView.animate(withDuration: 0.5, animations: {
                self.frontCardView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.frontCardView.alpha = 0.99
            })
        }
    }

}

