//
//  DetailViewController.swift
//  Milestone Project 19-21
//
//  Created by Loris on 6/13/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    let defaults = UserDefaults.standard
    
    @IBOutlet var textView: UITextView!
    
    var indexOfNote: Int?
    var detailNote: Note?
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let titleNote = detailNote {
            textView.text = titleNote.title
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
            
            // Hide done button when hiding keyboard
            navigationItem.setRightBarButton(nil, animated: true)
        } else {
            // If the keyboard is not hiding (it's visible) the bottom of the content inset will be the height of the keyboard
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            
            // Show Done button when showing keyboard
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done)), animated: true)
        }
        
        // Fix the scrolling indicator to not go below the keyboard
        textView.scrollIndicatorInsets = textView.contentInset
        
        // selectedRange is where is the cursor
        let selectedRange = textView.selectedRange
        // Scroll the view to the cursor
        textView.scrollRangeToVisible(selectedRange)
    }
    
    @objc func done() {
        // Add the note to the array of notes and then save
        if detailNote != nil {
            detailNote?.title = textView.text
            notes[indexOfNote!] = detailNote!
            save()
        } else if textView.text.count > 1 {
            let newNote = Note(title: textView.text, date: "00-00-00")
            notes.append(newNote)
            save()
        }
        
        // Go back to the first view controller in the navigation stack
        navigationController?.popViewController(animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()

        if let savedNotes = try? jsonEncoder.encode(notes) {
            defaults.set(savedNotes, forKey: "notes")
        } else {
            print("Failed to save notes.")
        }
    }

}
