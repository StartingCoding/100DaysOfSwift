//
//  ViewController.swift
//  Project28
//
//  Created by Loris on 7/24/19.
//  Copyright © 2019 Loris. All rights reserved.
//

// LocationAuthentication is the framework you can use for FaceID or TouchID
import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        // Set up notifications when keyboard changing frame every state of its size (show, hide, orientation, QuickType...)
        // and when hide keyboard animation is finished
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Set up notification when the app goes to background or the user go to the multitasking (aka the app is not in the foreground anymore)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        // UIResponder.keyboardFrameEndUserInfoKey is the frame of the keyboard when its animation has finished
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        // We take the size of the last frame of the kayboard (CGRect containing CGPoint and CGSize)
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        
        // We need to convert the CGRect of the keyboard to our view's coordinate (Fix if the user rotate the device)
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        // If the keyboard has finished hiding the content inset of textView will be 0
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            // If the keyboard is not hiding (it's visible) the bottom of the content inset will be the height of the keyboard
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        // Fix the scrolling indicator to not go below the keyboard
        secret.scrollIndicatorInsets = secret.contentInset
        
        // selectedRange is where is the cursor
        let selectedRange = secret.selectedRange
        // Scroll the view to the cursor
        secret.scrollRangeToVisible(selectedRange)
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        // Create the (Objective-C) object in order to work with authentication
        let context = LAContext()
        // Create a (Objective-C) error
        var error: NSError?
        
        // If the user can use a valid biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify Yourself!"
            
            // Let the user use biometric authentification mechanism (FaceID or TouchID)
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                
                // Make changes in the UI always on the main thread
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication Error!", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
                
            }
        } else {
            // This is a fallback for who doesn't have a FaceID or TouchID enabled
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometry authentication. Enter the password.", preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] action in
                // Return if the user didn't type anyting
                guard ac.textFields![0].text!.count > 0 else { return }
                guard let textFieldPass = ac.textFields![0].text else { return }
                
                // Make changes always on the main thread
                DispatchQueue.main.async {
                    // If the user typed the same password unlock secret stuff
                    if textFieldPass == KeychainWrapper.standard.string(forKey: "password") {
                        self?.unlockSecretMessage()
                        
                    // If the user typed the wrong password display an alert
                    } else if textFieldPass != KeychainWrapper.standard.string(forKey: "password") {
                        let ac = UIAlertController(title: "Wrong Password", message: nil, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                        
                    // If the user type  a password cut there is not a password already saved in the keychain, save it
                    } else if !KeychainWrapper.standard.hasValue(forKey: "password") {
                        KeychainWrapper.standard.set(textFieldPass, forKey: "password")
                        self?.unlockSecretMessage()
                    }
                }
                
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
        
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret Stuff"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSecretMessage))
        
        // KeychainWrapper is an easier way to managed iOS Keychain
        // If there is a key already saved in KeychainWrapper, load it.
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        // Save in the KeychainWrapper the text of the textView
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        
        // Notified that the textView is not on focus anymore so hide the keyboard
        secret.resignFirstResponder()
        
        secret.isHidden = true
        title = "Nothing to see here"
        navigationItem.rightBarButtonItem = .none
    }
    
}

