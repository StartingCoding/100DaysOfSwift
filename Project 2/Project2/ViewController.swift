//
//  ViewController.swift
//  Project2
//
//  Created by Loris on 28/03/2019.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var numberOfQuestions = 0
    var highScore = 0
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highScore = defaults.integer(forKey: "highScore")
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        askQuestion()
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(displayScore))
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "You're score is: \(score) - Guessing: \(countries[correctAnswer].uppercased())"
    }

    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            numberOfQuestions += 1
        } else {
            title = "Wrong, That's the flag of: \(countries[sender.tag].uppercased())"
            score -= 1
            numberOfQuestions += 1
        }
        
        if numberOfQuestions == 10 {
            if highScore < score {
                highScore = score
                save()
            }
            let final = UIAlertController(title: "You're final score is:", message: "\(score)", preferredStyle: .alert)
            final.addAction(UIAlertAction(title: "Restart", style: .default, handler: askQuestion))
            final.addAction(UIAlertAction(title: "View HighScore", style: .default) { [weak self] _ in
                let ac = UIAlertController(title: "Your HighScore is: \(self!.highScore)", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Restart", style: .cancel, handler: self?.askQuestion))
                self?.present(ac, animated: true)
            })
            present(final, animated: true)
            score = 0
            numberOfQuestions = 0
        } else {
            let ac = UIAlertController(title: title, message: "You're score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
    }
    
    @objc func displayScore() {
        let vc = UIAlertController(title: "Youre score is:", message: "\(score)", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Continue to Play Guess The Flag", style: .default))
        vc.addAction(UIAlertAction(title: "Share youre score", style: .default, handler: shareScore))
        present(vc, animated: true)
    }
    
    func shareScore(action: UIAlertAction! = nil) {
        let message = "I have \(score) points."
        let vc = UIActivityViewController(activityItems: [message], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func save() {
        defaults.set(highScore, forKey: "highScore")
    }
}

