//
//  ViewController.swift
//  Milestone Project 7-9
//
//  Created by Loris on 4/20/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var level = 0
    var wordToGuess = "something"
    var userWord = ""
    var charButtons = [UIButton]()
    
    var wordToGuessLabel: UILabel!
    var usedWordLabel: UILabel!
    var levelLabel: UILabel!
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.text = "Level: \(level)"
        levelLabel.backgroundColor = .red
        levelLabel.font = UIFont.systemFont(ofSize: 22)
        view.addSubview(levelLabel)
        
        wordToGuessLabel = UILabel()
        wordToGuessLabel.translatesAutoresizingMaskIntoConstraints = false
        wordToGuessLabel.text = "?????"
        wordToGuessLabel.backgroundColor = .blue
        wordToGuessLabel.font = UIFont.systemFont(ofSize: 44)
        view.addSubview(wordToGuessLabel)
        
        NSLayoutConstraint.activate([
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            levelLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            
            wordToGuessLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 20),
            wordToGuessLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
    
    func loadLevel() {
        if let url = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let contentUrl = try? String(contentsOf: url) {
                let parts = contentUrl.components(separatedBy: "\n")
                wordToGuess = parts[level]
            }
        }
    }
    
}

