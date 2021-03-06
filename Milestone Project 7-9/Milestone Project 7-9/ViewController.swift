//
//  ViewController.swift
//  Milestone Project 7-9
//
//  Created by Loris on 4/20/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var level = 0 {
        willSet {
            levelLabel.text = "\(newValue)"
        }
    }
    var loss = 0 {
        willSet {
            lossLabel.text = "\(newValue)"
        }
    }
    
    var wordToGuess = "something"
    var charButtons = [UIButton]()
    
    var levelLabel: UILabel!
    var lossLabel : UILabel!
    var wordToGuessLabel: UILabel!
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.text = "0"
        levelLabel.font = UIFont.systemFont(ofSize: 22)
        view.addSubview(levelLabel)
        
        lossLabel = UILabel()
        lossLabel.translatesAutoresizingMaskIntoConstraints = false
        lossLabel.text = "\(loss)"
        lossLabel.font = UIFont.systemFont(ofSize: 33)
        view.addSubview(lossLabel)
        
        wordToGuessLabel = UILabel()
        wordToGuessLabel.translatesAutoresizingMaskIntoConstraints = false
        wordToGuessLabel.text = String.init(repeating: "?", count: wordToGuess.count)
        wordToGuessLabel.font = UIFont.systemFont(ofSize: 44)
        view.addSubview(wordToGuessLabel)
        
        let charButtonsGroup = UIView()
        charButtonsGroup.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(charButtonsGroup)
        
        NSLayoutConstraint.activate([
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            levelLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            
            lossLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 20),
            lossLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            wordToGuessLabel.topAnchor.constraint(equalTo: lossLabel.bottomAnchor, constant: 20),
            wordToGuessLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            charButtonsGroup.topAnchor.constraint(equalTo: wordToGuessLabel.bottomAnchor, constant: 40),
            charButtonsGroup.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            charButtonsGroup.widthAnchor.constraint(equalToConstant: 650),
            charButtonsGroup.heightAnchor.constraint(equalToConstant: 300)
            ])
        
        let width = 50
        let height = 100
        
        for row in 0..<2 {
            for column in 0..<13 {
                let button = UIButton(type: .system)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                button.setTitle("W", for: .normal)
                button.widthAnchor.constraint(equalToConstant: 50)
                button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                button.frame = frame
                
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.lightGray.cgColor
                
                charButtonsGroup.addSubview(button)
                charButtons.append(button)
            }
        }
        
        for (index, char) in "abcdefghijklmnopqrstuvwxyz".enumerated() {
            charButtons[index].setTitle(String(char).uppercased(), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGame()
    }
    
    func newGame() {
        level = 0
        loss = 0
        loadLevel()
    }
    
    func loadLevel() {
        if let url = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let contentUrl = try? String(contentsOf: url) {
                let parts = contentUrl.components(separatedBy: "\n")
                
                if level == parts.count - 1 {
                    let ac = UIAlertController(title: "Winner Winner Chicken Dinner", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    ac.addAction(UIAlertAction(title: "Restart Game", style: .default) { [weak self] _ in
                        self?.newGame()
                    })
                    present(ac, animated: true)
                }
                
                wordToGuess = parts[level]
            }
        }
        
        for button in charButtons {
            button.isHidden = false
        }
        
        wordToGuessLabel.text = String.init(repeating: "?", count: wordToGuess.count)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let char = sender.titleLabel?.text else { return }
        
        if wordToGuess.contains(char.lowercased()) {
            var parts = wordToGuessLabel.text?.map { $0.uppercased() }
            
            for (index, item) in wordToGuess.enumerated() {
                if String(item) == char.lowercased() {
                    parts![index] = char.uppercased()
                }
            }
            
            wordToGuessLabel.text = parts?.joined()
            
            sender.isHidden = true
            
            if wordToGuessLabel.text?.lowercased() == wordToGuess {
                level += 1
                loss = 0
                loadLevel()
            }
        } else {
            loss += 1
            sender.isHidden = true
        }
        
        if loss == 7 {
            let ac = UIAlertController(title: "You Lose The Game", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try Again!", style: .default) { [weak self] _ in
                self?.loss = 0
                self?.loadLevel()
            })
            present(ac, animated: true)
        }
    }
}

