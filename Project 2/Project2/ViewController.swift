//
//  ViewController.swift
//  Project2
//
//  Created by Loris on 28/03/2019.
//  Copyright © 2019 Loris. All rights reserved.
//

import UserNotifications
import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var gameLabel: UILabel!
    
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(displayScore))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reminder", style: .plain, target: self, action: #selector(notification))
    }
    
    @objc func notification() {
        // Remove previous pending notifications
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        // Request permission to display notification
        requestPermissionNotification()
    }
    
    // Request permission to display notification
    func requestPermissionNotification() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                
                // Schedule notifications for 7 days
                for day in 1...7 {
                    self.scheduleForWeek(timeTrigger: TimeInterval(5 * day))
                }
                
            } else {
                self.performSelector(onMainThread: #selector(self.permissionDeniedAlert), with: nil, waitUntilDone: false)
            }
        }
    }
    
    @objc func permissionDeniedAlert() {
        let ac = UIAlertController(title: "That's a bummer", message: "If you want to be notified, you have to reset the notification's setting of the app.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(ac, animated: true)
    }
    
    // schedule for the week
    func scheduleForWeek(timeTrigger: TimeInterval) {
        let center = UNUserNotificationCenter.current()
        
        // Set up the content of the notification
        let content = UNMutableNotificationContent()
        content.title = "It's time to play"
        content.body = "Try to beat your highscore"
        content.categoryIdentifier = "alarm"
        content.sound = .default
        
        // Set up the trigger of the notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeTrigger, repeats: false)
        
        // Set up the request for the notification ( unique identifier - content - trigger )
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        gameLabel.text = "You're score is: \(score) - Guessing: \(countries[correctAnswer].uppercased())"
    }

    
    @IBAction func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.15, initialSpringVelocity: 5, options: [.curveEaseIn], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { finished in
            sender.transform = .identity
        }
        
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

