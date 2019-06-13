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
    }

}
