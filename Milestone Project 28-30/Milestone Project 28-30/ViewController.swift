//
//  ViewController.swift
//  Milestone Project 28-30
//
//  Created by Loris on 8/14/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
// https://unsplash.com/photos/IEISYENbXp8
    
    var card: UIImage!
    
    var cardView: UIImageView!
    
    override func loadView() {
        super.loadView()
        
        card = UIImage(named: "cardGame")
        cardView = UIImageView(image: card)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        // Do any additional setup after loading the view.
        
    }

}

