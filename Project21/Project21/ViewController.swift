//
//  ViewController.swift
//  Project21
//
//  Created by Loris on 6/1/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(tappedScheduleLocal))
    }

    // Request permission from user to dislay notification
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay")
            } else {
                print("D'oh!")
            }
        }
    }
    
    // Default behaviour for time trigger of 5 sec
    @objc func tappedScheduleLocal() {
        scheduleLocal(timeTrigger: 5)
    }
    
    @objc func scheduleLocal(timeTrigger: TimeInterval) {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeTrigger, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    // Set up categories - type of notification and buttons to do various actions
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let action = UNNotificationAction(identifier: "show", title: "Tell me more...", options: [.foreground])
        let secondAction = UNNotificationAction(identifier: "delayOneDay", title: "Remind me later", options: [])
        let category = UNNotificationCategory(identifier: "alarm", actions: [action, secondAction], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    // What to do after the user managed the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            //the user swiped to unlock
            showAlertInfo(title: "Default identifier")
            
        case "show":
            // the user clicked on Tell me more...
            showAlertInfo(title: "Show more information")
            
        case "delayOneDay":
            // the user clicked on Remind me later
            print("Tomorrow's notification")
            scheduleLocal(timeTrigger: 86400)
            
        default:
            break
        }
        
        completionHandler()
    }
    
    // Refactoring code - show alert details
    func showAlertInfo(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
}

