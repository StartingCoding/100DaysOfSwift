//
//  DetailViewController.swift
//  Milestone Project 19-21
//
//  Created by Loris on 6/13/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    var note: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let textNote = note {
            textView.text = textNote
        }
        
        // Set up notifications when keyboard changing frame every state of its size (show, hide, orientation, QuickType...)
        // and when hide keyboard animation is finished
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        // UIResponder.keyboardFrameEndUserInfoKey is the frame of the keyboard when its animation has finished
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        // We take the size of the last frame of the kayboard (CGRect containing CGPoint and CGSize)
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        
        // We need to convert the CGRect of the keyboard to our view's coordinate (Fix if the user rotate the device)
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        // If the keyboard has finished hiding the content inset of textView will be 0
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            // If the keyboard is not hiding (it's visible) the bottom of the content inset will be the height of the keyboard
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        // Fix the scrolling indicator to not go below the keyboard
        textView.scrollIndicatorInsets = textView.contentInset
        
        // selectedRange is where is the cursor
        let selectedRange = textView.selectedRange
        // Scroll the view to the cursor
        textView.scrollRangeToVisible(selectedRange)
    }

}
