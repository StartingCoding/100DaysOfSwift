//
//  Note.swift
//  Milestone Project 19-21
//
//  Created by Loris on 6/19/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class Note: Codable {
    var title: String
    var date: String
    
    init(title: String, date: String) {
        self.title = title
        self.date = date
    }
}
