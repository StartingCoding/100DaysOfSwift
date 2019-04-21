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
        levelLabel.font = UIFont.systemFont(ofSize: 22)
        view.addSubview(levelLabel)
        
        wordToGuessLabel = UILabel()
        wordToGuessLabel.translatesAutoresizingMaskIntoConstraints = false
        wordToGuessLabel.text = "?????"
        wordToGuessLabel.font = UIFont.systemFont(ofSize: 44)
        view.addSubview(wordToGuessLabel)
        
        let charButtonsGroup = UIView()
        charButtonsGroup.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(charButtonsGroup)
        
        NSLayoutConstraint.activate([
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            levelLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            
            wordToGuessLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 20),
            wordToGuessLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            charButtonsGroup.topAnchor.constraint(equalTo: wordToGuessLabel.bottomAnchor, constant: 20),
            charButtonsGroup.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            charButtonsGroup.widthAnchor.constraint(equalToConstant: 700),
            charButtonsGroup.heightAnchor.constraint(equalToConstant: 300)
            ])
        
        let width = 100
        let height = 100
        
        for row in 0..<3 {
            for column in 0..<7 {
                let button = UIButton(type: .system)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                button.setTitle("W", for: .normal)
                button.widthAnchor.constraint(equalToConstant: 100)
                button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                button.frame = frame
                
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.lightGray.cgColor
                
                charButtonsGroup.addSubview(button)
                charButtons.append(button)
            }
        }
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
    
    @objc func buttonTapped() {
        
    }
}

